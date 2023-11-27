#!/bin/bash

# Define constants
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
STUDENT_REPO_URL=$1
STUDENT_DIR="student-submission"
GRADING_DIR="grading-area"

# Remove existing directories
rm -rf $STUDENT_DIR
rm -rf $GRADING_DIR

# Create grading area directory
mkdir $GRADING_DIR

# Clone student's repository
git clone $STUDENT_REPO_URL $STUDENT_DIR
echo 'Finished cloning'

# Check if the correct file is submitted
if [ ! -f "$STUDENT_DIR/ListExamples.java" ]; then
    echo "Error: Incorrect file submitted. Please submit ListExamples.java."
    exit 1
fi

# Move necessary files to grading area
cp $STUDENT_DIR/ListExamples.java $GRADING_DIR/
cp TestListExamples.java $GRADING_DIR/
cp lib/*.jar $GRADING_DIR/

# Compile code
javac -cp $CPATH $GRADING_DIR/*.java

# Check for compilation errors
if [ $? -ne 0 ]; then
    echo "Error: Compilation failed. Please check your code for errors."
    exit 1
fi

# Run tests and capture JUnit output
echo .$CPATH
cd grading-area
TEST_RESULT=$(java -cp .$CPATH TestListExamples.java)
# Check if tests passed
if echo "$TEST_RESULT" | grep -q "FAILURES"; then
    echo "Tests failed. See detailed output below:"
    echo "$TEST_RESULT"
    exit 1
else
    echo "All tests passed! Congratulations!"
    exit 0
fi
