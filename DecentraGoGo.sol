// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StretchGoals.sol";
import "./DeadlineExtensions.sol";

contract DecentraGoGo is StretchGoals, DeadlineExtensions {
    mapping(address => uint) public contributors;
    address payable public admin;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline; // timestamp
    uint public goal;
    uint public raisedAmount;

    // Spending Request
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    // Mapping of spending requests
    // The key is the spending request number (index) - starts from zero
    // The value is a Request struct
    mapping(uint => Request) public requests;
    uint public numRequests;

    // Project Update
    struct ProjectUpdate {
        string description;
        uint timestamp;
    }

    // Mapping of project updates
    mapping(uint => ProjectUpdate) public projectUpdates;
    uint public numProjectUpdates;

    // Events to emit
    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address _recipient, uint _value);
    event StretchGoalAchievedEvent(uint _goalIndex, string _description, uint _targetAmount);
    event ProjectUpdateEvent(string _description);

    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        admin = payable(msg.sender); // Convert msg.sender to address payable
        minimumContribution = 100 wei;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute this");
        _;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "The Deadline has passed!");
        require(msg.value >= minimumContribution, "The Minimum Contribution not met!");

        // Check if any stretch goals have been achieved
        for (uint i = 0; i < stretchGoals.length; i++) {
            if (!stretchGoals[i].achieved && raisedAmount >= stretchGoals[i].targetAmount) {
                stretchGoals[i].achieved = true;
                emit StretchGoalAchievedEvent(i, stretchGoals[i].description, stretchGoals[i].targetAmount);
            }
        }

        // Incrementing the no. of contributors the first time when
        // someone sends ETH to the contract
        if (contributors[msg.sender] == 0) {
            noOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // A contributor can get a refund if the goal was not reached within the deadline
    function getRefund() public {
        require(block.timestamp > deadline, "Deadline has not passed.");
        require(raisedAmount < goal, "The goal was met");
        require(contributors[msg.sender] > 0);

        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];

        // Resetting the value sent by the contributor and transferring the value
        contributors[msg.sender] = 0;
        recipient.transfer(value);
    }

    function createRequest(string calldata _description, address payable _recipient, uint _value) public onlyAdmin {
        // numRequests starts from zero
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false; // Initialize as not completed
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function makePayment(uint _requestNo) public onlyAdmin {
        Request storage thisRequest = requests[_requestNo];
        require(!thisRequest.completed, "The request has been already completed!");
        require(thisRequest.noOfVoters > noOfContributors / 2, "The request needs more than 50% of the contributors to approve.");

        // Loop through stretch goals to find the approved one
        for (uint i = 0; i < stretchGoals.length; i++) {
            if (!stretchGoals[i].completed && stretchGoals[i].achieved) {
                // Update the current goal as completed
                stretchGoals[i].completed = true;
                goal -= stretchGoals[i].targetAmount; // Deduct the targetAmount from the goal

                // Admin can withdraw the specified amount for the completed goal
                admin.transfer(stretchGoals[i].targetAmount);

                // Emit an event to notify about the completed goal
                emit MakePaymentEvent(admin, stretchGoals[i].targetAmount);
            }
        }

        // Loop through requests to find the approved one
        for (uint i = 0; i < numRequests; i++) {
            if (!requests[i].completed) {
                requests[i].completed = true;
                admin.transfer(requests[i].value); // Admin withdraws funds for the request
                emit MakePaymentEvent(requests[i].recipient, requests[i].value);
            }
        }
    }

    function createProjectUpdate(string calldata _description) public onlyAdmin {
        // numProjectUpdates starts from zero
        ProjectUpdate storage newUpdate = projectUpdates[numProjectUpdates];
        numProjectUpdates++;

        newUpdate.description = _description;
        newUpdate.timestamp = block.timestamp;

        emit ProjectUpdateEvent(_description);
    }
}
