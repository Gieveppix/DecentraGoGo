# DecentraGoGo Smart Contract

DecentraGoGo is a Solidity smart contract designed for crowdfunding campaigns on the Ethereum blockchain. This contract provides a flexible crowdfunding platform with various features to support fundraising, spending requests, stretch goals, and deadline extensions. Below, you will find an overview of the contract's functionality and usage.

## Table of Contents

1. [Introduction](#introduction)
2. [Contract Details](#contract-details)
3. [Usage](#usage)
4. [Events](#events)

## Introduction

DecentraGoGo is a crowdfunding smart contract that allows creators to raise funds for their projects by accepting Ether contributions from the Ethereum community. Contributors can participate in campaigns, approve spending requests, and vote on deadline extensions. The contract is designed to ensure transparency and community involvement in crowdfunding efforts.

## Contract Details

### Contract Variables

- `contributors`: A mapping of contributor addresses to their contribution amounts.
- `admin`: The address of the contract administrator who has special privileges.
- `noOfContributors`: The total number of contributors to the campaign.
- `minimumContribution`: The minimum contribution required from contributors.
- `deadline`: The deadline for the crowdfunding campaign, represented as a timestamp.
- `goal`: The funding goal for the project.
- `raisedAmount`: The total amount of Ether raised.

### Structs

#### Spending Request

- `description`: A description of the spending request.
- `recipient`: The address that will receive the funds if the request is approved.
- `value`: The amount of Ether requested.
- `completed`: Indicates whether the spending request has been completed.
- `noOfVoters`: The number of contributors who have voted on this request.
- `voters`: A mapping of contributor addresses to their voting status on this request.

#### Stretch Goal

- `description`: A description of the stretch goal.
- `targetAmount`: The amount of funds required to achieve the stretch goal.
- `achieved`: Indicates whether the stretch goal has been achieved.
- `deadline`: The deadline for achieving this stretch goal.
- `completed`: Indicates whether the stretch goal has been completed.

#### Deadline Extension

- `reason`: The reason for requesting a deadline extension.
- `newDeadline`: The new deadline proposed for the campaign.
- `completed`: Indicates whether the deadline extension has been completed.
- `noOfApprovers`: The number of contributors who have approved the extension.
- `approvers`: A mapping of contributor addresses to their approval status.

### Mapping and Arrays

- `requests`: A mapping of spending requests, indexed by request number.
- `numRequests`: The total number of spending requests.
- `stretchGoals`: An array of stretch goal structs.
- `deadlineExtensions`: A mapping of deadline extensions, indexed by extension number.
- `numDeadlineExtensions`: The total number of deadline extensions.

### Modifiers

- `onlyAdmin`: A modifier that restricts certain functions to the contract administrator (admin).

## Usage

The DecentraGoGo contract can be used to create and manage crowdfunding campaigns. Key functions and their purposes include:

- `contribute`: Contributors can send Ether to the contract and become part of the campaign. The contract tracks contributor addresses and contribution amounts.

- `getRefund`: Contributors can request a refund if the campaign does not meet its goal within the specified deadline.

- `createRequest`: The contract administrator can create spending requests, specifying the recipient and amount to be spent.

- `setStretchGoal`: The contract administrator can set stretch goals, which are additional funding targets that, when reached, unlock new features or benefits.

- `createDeadlineExtensionRequest`: The administrator can request a deadline extension with a reason and a new proposed deadline.

- `approveDeadlineExtension`: Contributors can approve a deadline extension request, which, when approved by a sufficient majority, updates the campaign's deadline.

- `voteRequest`: Contributors can vote on spending requests.

- `makePayment`: The administrator can finalize spending requests, transferring funds to recipients.

## Events

The contract emits various events to provide transparency and facilitate tracking:

- `ContributeEvent`: Emitted when a contributor makes a contribution.
- `CreateRequestEvent`: Emitted when a spending request is created.
- `MakePaymentEvent`: Emitted when a payment is made to a recipient.
- `CreateDeadlineExtensionRequestEvent`: Emitted when a deadline extension request is created.
- `StretchGoalAchievedEvent`: Emitted when a stretch goal is achieved.
- `DeadlineExtensionApprovedEvent`: Emitted when a deadline extension request is approved.

Please note that this contract is intended for educational purposes and should be thoroughly reviewed and tested before being used in production environments.