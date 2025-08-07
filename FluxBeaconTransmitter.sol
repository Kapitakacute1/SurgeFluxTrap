// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FluxBeaconTransmitter {
    event FluxAlert(bytes payload);

    function transmit(bytes calldata payload) external {
        emit FluxAlert(payload);
    }
}
