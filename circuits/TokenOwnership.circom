pragma circom 2.1.4;

include "circomlib/circuits/comparators.circom";

template TokenOwnership() {
    signal input balance;      // Приватный баланс
    signal input walletHash;   // Приватный хэш адреса кошелька
    signal input threshold;    // Публичный порог
    signal input pubHash;      // Публичный хэш адреса кошелька

    // Проверка: balance >= threshold
    component comp = GreaterEqThan(252);
    comp.in[0] <== balance;
    comp.in[1] <== threshold;

    // Ограничение: comp.out должно быть 1, если balance >= threshold
    comp.out === 1;

    // Проверка совпадения хэшей
    walletHash === pubHash;
}

component main = TokenOwnership();
