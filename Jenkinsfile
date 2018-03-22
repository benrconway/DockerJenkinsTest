#!/usr/bin/env groovy

pipeline {
    agent any
    environment {

      // Tool declaration allows the path of tools to differ between OSs
      MAVEN = tool('MavenTool')
      DOCKER = tool('testDocker')
      // SLACK_TOKEN = credentials('company_slack_token')
    }
    stages {
      stage('Build') {
          steps {
            // Use of tool allows for greater portability across platforms.
            sh "${DOCKER}/Contents/Resources/bin/docker build -q -t api ."
            sh "${DOCKER}/Contents/Resources/bin/docker create --name npm_script_test -p 3000:3000 api"
            sh "${DOCKER}/Contents/Resources/bin/docker start npm_script_test"
            sh "${DOCKER}/Contents/Resources/bin/docker ps -a"

            // Future proofing attempts to make it wait for the server to be
            // running before continuing
            // First answer to the problem raised by the time between starting
            // the container and being able to hit the api
            // sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -f status=running | grep -e $1 | wc -l"
            // Modification for this pipeline
            // sh "${DOCKER}/Contents/Resources/bin/docker container ls -f status=running | grep -e npm_script_test | wc -l"

            // Addition of this script allows us to know that the pipeline will
            // not continue until the server is live and healthy.
            sh "./serverCheck.sh"

            // This curl is here to ping the api and act as redundancy for the serverCheck script above.
            sh 'curl -f http://0.0.0.0:3000/api || echo "Test 1 failed"'

            // In Jenkins2 it is also possible to use more inbuilt commands, ie
            // docker.build()
            // docker.run()
            // with extra arguments listed inside the round brackets.
          }
      }
      stage('Test') {
          steps {
                echo 'Testing now.'

                // The Docker container and server is currently running in the
                // background, so below I am creating and moving into a new directory
                // in the Jenkins Pipeline. Inside this new directory, I clone
                // the named git repo and run the following nodejs commands.
                // With Node:
                // dir('test'){
                //   git url: 'https://github.com/benrconway/JenkinsTest2.git'
                //   nodejs('testJS'){
                //     sh 'npm install'
                //     sh 'npm test'
                //   }
                // }
                // With Maven:
                dir('test'){
                  git url: 'https://github.com/benrconway/MavenJenkins.git'
                  // withMaven(maven:'MavenTool') {
                  //     sh "mvn test"
                  //   }
                    sh "${MAVEN}/bin/mvn clean test" 
                  }
                }
      }
      stage('Deploy') {
          steps {
              echo 'Deploying'
              // At this stage we will deploy our file wherever it needs to go.
          }
      }
      stage('Cleanup'){
        steps{
            echo 'Cleaning up'
            // Here I will turn off the container, remove it and associated images.
            // Then I will use the final command to clean the current workspace
            // ready for the next time the job is run

            // Stop the running container
            sh "${DOCKER}/Contents/Resources/bin/docker stop npm_script_test"
            // Remove the stopped container
            sh "${DOCKER}/Contents/Resources/bin/docker rm npm_script_test"
            // Remove image now that it is "dangling" (has no associated container)
            sh "${DOCKER}/Contents/Resources/bin/docker rmi api"

            // Final check to be sure all images and containers are removed.
            sh "${DOCKER}/Contents/Resources/bin/docker container ls -a"
            sh "${DOCKER}/Contents/Resources/bin/docker images ls -a"
            sh "${DOCKER}/Contents/Resources/bin/docker ps -aq --no-trunc"

            // This is a Jenkins function that cleans the workspace completely.
            deleteDir()

          }
        }
    }
}


    // Slacking is something I want to understand how to make work in general.
    // post {
    //      success {
    //          slackSend baseUrl: '$company_slack_url', channel: '#channelName', color: '#007F00', message: ":celeryman: Success! :celeryman: ${env.JOB_NAME} ${env.BUILD_ID}", tokenCredentialId: '$SLACK_TOKEN'
    //      }
    //
    //      failure {
    //          slackSend baseUrl: '$company_slack_url', channel: '#channelName', color: '#E63247', message: ":explodinghead: ${env.JOB_NAME} ${env.BUILD_ID}", tokenCredentialId: '$SLACK_TOKEN'
    //      }
    //  }
