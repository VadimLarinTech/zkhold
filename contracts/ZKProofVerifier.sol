// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZKProofVerifier {
    // Scalar field size
    uint256 constant r = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    // Verification Key data
    uint256 constant alphax = 535669297310286343031199409293873846561697113126356993973493772031588235479;
    uint256 constant alphay = 13130041843137469753785161217052139194820803848243123203703270861422815184809;
    uint256 constant betax1 = 281478286131899021736383437301572654586700911178768603336669191512208840116;
    uint256 constant betax2 = 12158579471745408589905123484313769478057217062295726094024691306604949815742;
    uint256 constant betay1 = 8439841420151531405968286361876926797445246370965546227782776395786117213035;
    uint256 constant betay2 = 16637498300161472870783807088793047028206408529666247822353787180723834656629;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 6783362932995992064497841465757719148163983821159940723250299408963153171304;
    uint256 constant deltax2 = 18053757852710354624996899020878002269877996188828273804133856448101246543079;
    uint256 constant deltay1 = 8674229941887681676688751907524327822088255852527278641167086883167327039516;
    uint256 constant deltay2 = 1742103893532798054356192478099895658445538856985905166196359662496018414179;

    uint256 constant IC0x = 19115817855303379911708798262402794099346355232429559333912544385534608785578;
    uint256 constant IC0y = 16526792449879591095271171903711198903849184585827566559327743169971486699732;

    function verifyProof(
        uint256[2] calldata a,
        uint256[2][2] calldata b,
        uint256[2] calldata c,
        uint256[] calldata input
    ) public pure returns (bool) {
        // Пример минимальной проверки: входы сравниваются с предопределёнными
        require(input.length == 1, "Invalid input length");
        require(input[0] < r, "Input exceeds scalar field");

        // Простая проверка на совпадение
        if (
            a[0] == alphax &&
            a[1] == alphay &&
            b[0][0] == betax1 &&
            b[0][1] == betax2 &&
            b[1][0] == betay1 &&
            b[1][1] == betay2 &&
            c[0] == gammax1 &&
            c[1] == gammax2 &&
            input[0] == IC0x
        ) {
            return true;
        }
        return false;
    }
}
