node {
    // this defines a variable we can use later. Presently I have no use for it.
    // def app

    // Not certain of tool settings or environment inside of this form of pipeline.
    environment{
      tools {docker "testDocker"}
    }
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
          //     /* This builds the actual image; synonymous to
          //      * docker build on the command line */
          //     // app = docker.build("api")

          // I have opted for clarity of CLI commands.
          sh "/Applications/Docker.app/Contents/Resources/bin/docker build -q -t api ."
          sh "/Applications/Docker.app/Contents/Resources/bin/docker create --name npm_script_test -p 3000:3000 api"
          sh "/Applications/Docker.app/Contents/Resources/bin/docker start npm_script_test"
          sh "/Applications/Docker.app/Contents/Resources/bin/docker ps -a"
          sh "${docker}/Contents/Resources/bin/docker ps -a"

          //Future proofing attempts to make it wait for the server to be running before continuing
          // sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -f status=running | grep -e $1 | wc -l"
          sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -f status=running | grep -e npm_script_test | wc -l"

          // This one has yet to pass, theory is separate thread is starting up the
          // docker image, so server isn't there yet.
          sh 'curl -f http://0.0.0.0:3000/api || echo "Test 1 failed"'

          //     Below are FAILED commands
          //     //This one works in my docker container jenkins.
          //     // sh 'docker build -t api .'
          //
          //     //Experiment to see if I can get docker on my personal machine working
          //     // sh "sh ${DOCKER}/Contents/Resources/bin/docker build -t api . "
    }

    stage('Test image') {
         // This is an alternate style of docker command within Jenkins, however,
         // I don't understand it and prefer the simplicity(if convoluted) of CLI
         // sh 'docker build -t api .'
         // docker.run("api")
         // docker.logs("api")

         // app.run()

         //This should work.
         // Checking status of containers.
         sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls"

         // There seems to be an issue of starting up, but as it is started in the
         // stage above, I am not concerned at present.
         // sh 'timeout 5'

         //Simple curls to test if pinging the address works.
         // sh 'curl -f http://127.0.0.1:3000/api || echo "ip#127 failed"'
         // sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls"
         // sh 'curl -f http://0.0.0.0:3000/api || echo "Test 1 failed"'
         // sh 'curl -f http://localhost:3000/api || echo "Test 2 failed"'
         // as of last run, all were successful in sampling the JSON stored


         // Test to bring BDD test stored outside Docker in to run tests on
         // container logic
         dir('test'){
           git url: 'https://github.com/benrconway/JenkinsTest2.git'
           nodejs('testJS'){
             sh 'npm install'
             sh 'npm test'
           }
         }
         // Just a final check on the status of the container we have run.
         sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls"

         // sh "/Applications/Docker.app/Contents/Resources/bin/docker stop loving_sinoussi"

         //
         //
         // Below is an experiment in redirecting logs to somewhere I can get them without
         // looking into Jenkins directly.

        // $echo '' < app.container("logs")
        // trying to see what it written instead of just receiving success  notification
        // app.inside{
        //   sh 'npm test'
        //}
    }

    stage('Deploy'){
      sh 'echo Deploy should be here'

    }

    stage('Cleanup'){
      //Here I will turn off all containers, remove containers, images etc
      // Clean up is a good word for it. This way all resources output no junk.

      //Stops the running container
      sh "/Applications/Docker.app/Contents/Resources/bin/docker stop npm_script_test"
      // Remove the stopped container
      sh "/Applications/Docker.app/Contents/Resources/bin/docker rm npm_script_test"
      // Remove image now that it is "dangling"
      sh "/Applications/Docker.app/Contents/Resources/bin/docker rmi api"

      // Removes all stopped containers.
      // -aq = Only Id of all containers
      // --no-trunc prevents truncating the output (everthing runs together)
      // it then passes the commands by manner of pipe to docker rm
      //sh "/Applications/Docker.app/Contents/Resources/bin/docker ps -aq --no-trunc | xargs docker rm"
      // Above doesn't work as pipe doesn't seem to behave appropriately.

      // Final check to be sure all images and containers are removed.
      sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -a"
      sh "/Applications/Docker.app/Contents/Resources/bin/docker images ls -a"
      // sh "/Applications/Docker.app/Contents/Resources/bin/docker ps -aq --no-trunc | xargs docker rm "
      sh "/Applications/Docker.app/Contents/Resources/bin/docker ps -aq --no-trunc"

      //Removes docker images which are not being used by any containers.
      // -q is quiet output, filter is straightforward and again it is
      // piped to docker rmi.
      // sh "/Applications/Docker.app/Contents/Resources/bin/docker images -q --filter dangling=true | xargs docker rmi"

     }
    // Slacking is something I want to understand how to make work in general.
    // post {
    //      success {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '', color: '#007F00', message: "Success ${env.JOB_NAME} ${env.BUILD_ID} (<${env.JENKINS_URL}/job/PwcCompliance/${env.BUILD_ID}|Open>)", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //
    //      failure {
    //          slackSend baseUrl: 'https://bemohq.slack.com/services/hooks/jenkins-ci/', channel: '#pwc', color: '#E63247', message: "******:fire:FAILURE:fire:****** ${env.JOB_NAME} ${env.BUILD_ID} (<${env.JENKINS_URL}/job/PwcCompliance/${env.BUILD_ID}|Open>)", tokenCredentialId: '$PWC_SLACK_TOKEN'
    //      }
    //  }
}
