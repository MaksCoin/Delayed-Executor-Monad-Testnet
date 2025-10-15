// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DelayedExecutor {
    uint256 public nextId;

    struct Order {
        address creator;
        address target;
        uint256 value;
        bytes data;
        uint256 executeAfter;
        bool executed;
    }

    mapping(uint256 => Order) public orders;

    event OrderCreated(uint256 indexed id, address indexed creator, address target, uint256 value, uint256 executeAfter);
    event OrderExecuted(uint256 indexed id, address indexed executor, bool success, bytes returnData);

    constructor() {
        nextId = 1;
    }

    function createOrder(address target, bytes calldata data, uint256 executeAfter) external payable returns (uint256) {
        require(executeAfter > block.timestamp, "executeAfter must be in future");

        uint256 id = nextId;
        nextId += 1;

        orders[id] = Order({
            creator: msg.sender,
            target: target,
            value: msg.value,
            data: data,
            executeAfter: executeAfter,
            executed: false
        });

        emit OrderCreated(id, msg.sender, target, msg.value, executeAfter);
        return id;
    }

    function execute(uint256 id) external {
        Order storage o = orders[id];
        require(o.creator != address(0), "no such order");
        require(!o.executed, "already executed");
        require(block.timestamp >= o.executeAfter, "too early");

        o.executed = true;

        (bool success, bytes memory ret) = o.target.call{value: o.value}(o.data);
        emit OrderExecuted(id, msg.sender, success, ret);

        require(success, "call failed");
    }

    receive() external payable {}
}
