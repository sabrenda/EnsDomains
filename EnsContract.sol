// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Ens {
    struct DomainInfo {
        address owner;
        uint256 registrationTime;
        uint256 price;
    }

    mapping(string => DomainInfo) private domains;

    address public owner;

    // Объявление события для лога
    event DomainRegistered(string domain, address owner, uint256 price);

    // Проверка на owner
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    // Проверка на присутствие домена в мапе
    modifier domainNotRegistered(string memory domain) {
        require(
            domains[domain].owner == address(0),
            "Domain is already registered"
        );
        _;
    }

    // Конструктор для присвоения owner адреса того кто деплоит контракт
    constructor() {
        owner = msg.sender;
    }

    // Регистрация домена
    function registerDomain(
        string memory domain
    ) public payable domainNotRegistered(domain) {
        require(msg.value > 0, "Registration fee is required");

        domains[domain] = DomainInfo({
            owner: msg.sender,
            registrationTime: block.timestamp,
            price: msg.value
        });

        // Эмиссия события, для того чтобы записать событие в лог транзакции
        emit DomainRegistered(domain, msg.sender, msg.value);
    }

    // Получение адреса владельца по домену
    function getDomainOwner(
        string memory domain
    ) public view returns (address) {
        return domains[domain].owner;
    }

    // Снятие средств с контракта
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
