
import os
import json
import uuid
from pprint import pprint

import boto3

def sample_input():
    return {
        "run_web_tests" : "TRUE",
        "web_test_config": {
            "RUN_TAG" : "TEST",
            "BROWSERS" : json.dumps(["Chrome", "Edge", "Firefox"])},
        "run_app_tests" : "FALSE",
        "run_platform_tests" : "TRUE"}

def lambda_handler(event, context):
    sfn = boto3.client("stepfunctions")
    sma = os.getenv("STATE_MACHINE_ARN")
    description = sfn.describe_state_machine(stateMachineArn=sma)

    pprint(description)
    input = sample_input()
    input["EXECUTION_ID"] = str(uuid.uuid4())
    start_info = sfn.start_execution(stateMachineArn=sma, input=json.dumps(input))
    print("State Machine Input :")
    pprint(input)
    print("State Machine Execution Info")
    pprint(start_info)