#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
      CI = 'true'
      //Tool declaration allows the path of tools to differ between OSs
      DOCKER = tool('testDocker')
      // BMAS_SLACK_TOKEN = credentials('bmas_jenkins_slack')
    }
    stages {
      // stage('Prepare the Scene'){
      //   steps{
      //     echo "Building construction area"
      //     // Stops a running container.
      //     sh "${DOCKER}/Contents/Resources/bin/docker stop npm_script_test"
      //     // Remove the stopped container
      //     sh "${DOCKER}/Contents/Resources/bin/docker rm npm_script_test"
      //     // Remove image now that it is "dangling"
      //     sh "${DOCKER}/Contents/Resources/bin/docker rmi api"
      //   }
      // }
      stage('Build') {
          steps {
            //Ensure nothing running, and all clean

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

             //This curl is here to ping the api and act as redundancy for the serverCheck script above.
             sh 'curl -f http://0.0.0.0:3000/api || echo "Test 1 failed"'
          }
      }
      stage('Test') {
          steps {
                echo 'Testing now.'

                // The Docker container and server is currently running in the
                // background, so below I am creating and moving into a new directory
                // in the Jenkins Pipeline. Inside this new directory, I clone
                // the named git repo and run the following nodejs commands.
                dir('test'){
                  git url: 'https://github.com/benrconway/JenkinsTest2.git'
                  nodejs('testJS'){
                    sh 'npm install'
                    sh 'npm test'
                  }
                }

          }
      }
      stage('Deploy') {
          steps {
              echo 'Deploying'
              //We don't have anything except theories for this part.
          }
      }
      stage('Cleanup'){
        steps{
            echo 'Cleaning up'
            //Here I will turn off all containers, remove containers, images etc
            // Clean up is a good word for it. This way all resources output no junk.

            //Stops the running container
            sh "${DOCKER}/Contents/Resources/bin/docker stop npm_script_test"
            // Remove the stopped container
            sh "${DOCKER}/Contents/Resources/bin/docker rm npm_script_test"
            // Remove image now that it is "dangling"
            sh "${DOCKER}/Contents/Resources/bin/docker rmi api"

            // Final check to be sure all images and containers are removed.
            sh "${DOCKER}/Contents/Resources/bin/docker container ls -a"
            sh "${DOCKER}/Contents/Resources/bin/docker images ls -a"
            sh "${DOCKER}/Contents/Resources/bin/docker ps -aq --no-trunc"
            sh 'ls -al'
          }
        }
    }
}


    // // Slacking is something I want to understand how to make work in general.
    // post {
    //      success {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '#bmas', color: '#007F00', message: ":celeryman: Success! :celeryman: ${env.JOB_NAME} ${env.BUILD_ID}", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //
    //      failure {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '#bmas', color: '#E63247', message: ":explodinghead: ${env.JOB_NAME} ${env.BUILD_ID}", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //  }
