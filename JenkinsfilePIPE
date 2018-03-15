#!/usr/bin/env groovy

pipeline {


    agent any
    environment {
      CI = 'true'
      DOCKER = tool('testDocker')
    }
    stages {
        stage('Build') {
            steps {
              // docker('testDocker'){
              //   sh 'docker build -t api .'
              //   }
              sh "${DOCKER}/Contents/Resources/bin/docker build -t api ."

            }
        }
        // stage('Test') {
        //     steps {
        //         echo 'Testing.. and stuff'
        //
        //         // app.run()
        //         // nodejs('testJS') {
        //         //     sh "npm test"
        //         // }
        //
        //
        //     }
        // }
        // stage('Deploy') {
        //     steps {
        //         echo 'Deploying....'
        //     }
        // }
    }
}

// how does this change things
// pipeline {
//     agent any
//     stages {
//         stage('Build') {
//             steps {
//                 echo "building..."
//             }
//         }
//         stage('Test'){
//             steps {
//                 sh ''
//                 junit 'reports/**/*.xml'
//             }
//         }
//         stage('Deploy') {
//             steps {
//                 sh 'make publish'
//             }
//         }
//     }
// }
