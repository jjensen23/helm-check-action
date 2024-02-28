#!/bin/bash -l

function printDelimeter {
  echo "----------------------------------------------------------------------"
}

function printLargeDelimeter {
  echo -e "\n\n------------------------------------------------------------------------------------------\n\n"
}

function printStepExecutionDelimeter {
  echo "----------------------------------------"
}

function displayInfo {
  echo
  printDelimeter
  echo
  HELM_CHECK_VERSION="v0.2.0"
  HELM_CHECK_SOURCES="https://github.com/jjensen23/helm-check-action"
  echo "Helm-Check $HELM_CHECK_VERSION"
  echo -e "Source code: $HELM_CHECK_SOURCES"
  echo
  printDelimeter
}

function retrieveValues {
  echo "Attempting to locate additional values files"
  printDelimeter
  if [ -n "$CHART_VALUES_DIR" ]; then
    CHART_VALUES_FILES=$(find "$CHART_VALUES_DIR" -type f \( -name "*.yaml" -o -name "*.yml" \))
    printf "Located the following values files:\\n$CHART_VALUES_FILES\\n"
  fi
  printDelimeter
  echo
}

function helmLint {
  echo -e "\n\n\n"
  echo -e "1. Checking a chart for possible issues\n"
  if [ -z "$CHART_LOCATION" ]; then
    echo "Skipped due to condition: \$CHART_LOCATION is not provided"
    return -1
  fi
  echo "helm lint $CHART_LOCATION"
  printStepExecutionDelimeter
  helm lint "$CHART_LOCATION"
  HELM_LINT_EXIT_CODE=$?
  printStepExecutionDelimeter
  if [ $HELM_LINT_EXIT_CODE -eq 0 ]; then
    echo "Result: SUCCESS"
  else
    echo "Result: FAILED"
  fi
  return $HELM_LINT_EXIT_CODE
}

function helmTemplate {
  printLargeDelimeter
  echo -e "2. Trying to render templates with provided values\n"
  local EXIT_CODE=0

  if [[ "$1" -eq 0 ]]; then
    if [ -n "$CHART_VALUES" ]; then
      if [ -n "$CHART_VALUES_DIR" ]; then
        retrieveValues
        if [ -n "$CHART_VALUES_FILES" ]; then
          IFS=$'\n'
          for chart_values_file in $CHART_VALUES_FILES; do
            echo "helm template --values $CHART_VALUES --values $chart_values_file $CHART_LOCATION"
            printDelimeter
            helm template --values "$CHART_VALUES" --values "$chart_values_file" "$CHART_LOCATION"
            HELM_TEMPLATE_EXIT_CODE=$?
            printStepExecutionDelimeter
            if [ $HELM_TEMPLATE_EXIT_CODE -eq 0 ]; then
              echo "Result: SUCCESS"
            else
              echo "Result: FAILED"
              EXIT_CODE=$HELM_TEMPLATE_EXIT_CODE
            fi
          done
          unset IFS
        fi
      else
        echo "helm template --values $CHART_VALUES $CHART_LOCATION"
        printDelimeter
        helm template --values "$CHART_VALUES" "$CHART_LOCATION"
        HELM_TEMPLATE_EXIT_CODE=$?
        printStepExecutionDelimeter
        if [ $HELM_TEMPLATE_EXIT_CODE -eq 0 ]; then
          echo "Result: SUCCESS"
        else
          echo "Result: FAILED"
          EXIT_CODE=$HELM_TEMPLATE_EXIT_CODE
        fi
      fi
    else
      printStepExecutionDelimeter
      echo "Skipped due to condition: \$CHART_VALUES is not provided"
      printStepExecutionDelimeter
    fi
  else
    echo "Skipped due to failure: Previous step has failed"
    EXIT_CODE=$1
  fi
  return $EXIT_CODE
}

function totalInfo {
  printLargeDelimeter
  echo -e "3. Summary\n"
  if [[ "$1" -eq 0 ]]; then
    echo "Examination is completed; no errors found!"
    exit 0
  else
    echo "Examination is completed; errors found, check the log for details!"
    exit 1
  fi
}

displayInfo
helmLint
helmTemplate $?
totalInfo $?