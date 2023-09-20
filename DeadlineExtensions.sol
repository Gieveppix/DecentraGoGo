// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadlineExtensions {
    struct DeadlineExtension {
        string reason;
        uint newDeadline;
        bool completed;
        uint noOfApprovers;
        mapping(address => bool) approvers;
    }

    DeadlineExtension[] public deadlineExtensions;

    event CreateDeadlineExtensionRequestEvent(string _reason, uint _newDeadline);
    event DeadlineExtensionApprovedEvent(uint _extensionNo, uint _newDeadline);

    function createDeadlineExtensionRequest(string calldata _reason, uint _newDeadline) public {
        DeadlineExtension storage newExtension = deadlineExtensions.push();
        newExtension.reason = _reason;
        newExtension.newDeadline = _newDeadline;
        newExtension.completed = false;
        newExtension.noOfApprovers = 0;

        emit CreateDeadlineExtensionRequestEvent(_reason, _newDeadline);
    }

    function approveDeadlineExtension(uint _extensionNo) public {
        require(_extensionNo < deadlineExtensions.length, "Invalid extension number");
        DeadlineExtension storage thisExtension = deadlineExtensions[_extensionNo];
        require(!thisExtension.approvers[msg.sender], "You have already voted!");

        thisExtension.approvers[msg.sender] = true;
        thisExtension.noOfApprovers++;

        if (thisExtension.noOfApprovers > (deadlineExtensions.length * 70) / 100) {
            emit DeadlineExtensionApprovedEvent(_extensionNo, thisExtension.newDeadline);
        }
    }
}
