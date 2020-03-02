<#
.Synopsis
DPi30 Determine Template Function

.Description
Determines the best template to deploy based on the questions asked.
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
function DetermineTemplate {
    # Questionaire to determine best fit, Current logic is if you answer yes at least twice you should use Modern Data Warehouse, otherwise we check if you want to use any DBMI features
    $dwscore = 0
    Write-Host "`r`nLet's determine the best deployment for your situation, Please answer the next few questions with y (yes) or n (no)."
    
    $dwscore = DwScoreCalculator -Question "`r`nWill you have more than 1 TB of data?" -DwScore $dwscore
    
    $dwscore = DwScoreCalculator -Question "`r`nDo you have a highly analytics-based workload?" -DwScore $dwscore
 
    $dwscore = DwScoreCalculator -Question "`r`nDo you want to utilize any real-time or streaming data?" -DwScore $dwscore

    $dwscore = DwScoreCalculator -Question "`r`nWould you like to integrate machine learning into your business intelligence?" -DwScore $dwscore

    $dwscore = DwScoreCalculator -Question "`r`nDo you have Python, Scala, R, or Spark experience?" -DwScore $dwscore

    if ($dwscore -ge 2) {
        return "moderndatawarehouse"
    } else {
        $InputMessage = "`r`nWould you like to use SQL Agent, Cross Database Queries, or replicate between other SQL Servers?"
        $confirmation = Read-Host $InputMessage
        $valid = BoolValidation -UserInput $confirmation
        while(!($valid.Result)) {
            $confirmation = Read-Host $InputMessage
            $valid = BoolValidation -UserInput $confirmation
        }
        if ($confirmation.ToLower().SubString(0,1) -eq "y") {
            return "managedinstance"
        } else {
            return "simple"
        }
    }
}

function DwScoreCalculator {
    Param(
        #question asked
        $question,
        #Score for DW
        $dwscore
    )
    
    $confirmation = Read-Host $question
    $valid = BoolValidation -UserInput $confirmation 
    while(!($valid.Result)) {
        Write-Host $valid.Message -ForegroundColor Yellow
        $confirmation = Read-Host $question
        $valid = BoolValidation -UserInput $confirmation 
    }
    
    if ($confirmation.ToLower().SubString(0,1) -eq "y") {
        $dwscore++
    }

    return $dwscore
}