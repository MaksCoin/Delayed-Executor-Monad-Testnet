// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DelayedExecutor (payable version)
 * @notice Контракт для хранения и выполнения отложенных ордеров. 
 * Теперь createOrder — payable, и вы можете передать ETH/MON (native) как часть ордера.
 * При исполнении execute, контракт пересылает заданное значение + вызывает данные (data).
 */
contract DelayedExecutor {
    uint256 public nextId;

    struct Order {
        address creator;
        address target;
        uint256 value;        // сумма (native) которую нужно отправить при выполнении
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

    /**
     * Создаёт ордер; payable — можно передавать сумму, которая будет храниться в контракте.
     * @param target адрес, куда будет вызван call
     * @param data calldata (function + params)
     * @param executeAfter unix timestamp после которого можно вызывать исполнение
     * @return id созданного ордера
     */
    function createOrder(address target, bytes calldata data, uint256 executeAfter) external payable returns (uint256) {
        require(executeAfter > block.timestamp, "executeAfter must be in future");

        uint256 id = nextId;
        nextId += 1;

        // записываем ордер с присланной суммой
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

    /**
     * Выполняет ордер. Передаёт value и вызывает call с data.
     * @param id идентификатор ордера
     */
    function execute(uint256 id) external {
        Order storage o = orders[id];
        require(o.creator != address(0), "no such order");
        require(!o.executed, "already executed");
        require(block.timestamp >= o.executeAfter, "too early");

        o.executed = true;

        // передаём value (если > 0) и вызываем target.call(data)
        (bool success, bytes memory ret) = o.target.call{value: o.value}(o.data);
        emit OrderExecuted(id, msg.sender, success, ret);

        require(success, "call failed");
    }

    // Приёмник нативных средств — если кто-то случайно отправит ETH/MON напрямую
    receive() external payable {}
}
