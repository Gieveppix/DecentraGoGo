// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StretchGoals {
    // Struct for Stretch Goals
    struct StretchGoal {
        string description;
        uint targetAmount;
        bool achieved;
        uint deadline; // Each stretch goal's deadline
        bool completed;
    }

    // Mapping of Stretch Goals
    StretchGoal[] public stretchGoals;

    // Function to set a new stretch goal
    function setStretchGoal(string calldata _description, uint _targetAmount, uint _stretchGoalDeadline) public {
        StretchGoal memory newGoal = StretchGoal(_description, _targetAmount, false, _stretchGoalDeadline, false);
        stretchGoals.push(newGoal);
    }
}
