// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

/// @title SurgeFluxTrap — triggers on subtle basefee shifts
contract SurgeFluxTrap is ITrap {
    function collect() external view override returns (bytes memory) {
        return abi.encode(block.basefee);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) {
            return (false, bytes("Insufficient samples"));
        }

        uint256 current = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        uint256 delta = current > previous ? current - previous : previous - current;
        uint256 threshold = previous / 66; // ~1.5%

        if (delta > threshold) {
            return (true, abi.encode("Basefee flux >1.5%"));
        }

        return (false, bytes("Stable basefee"));
    }
}
