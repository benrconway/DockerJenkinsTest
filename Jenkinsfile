node {

    def app
    environment{
      //What is this even doing for me today?
      tools {docker "testDocker"}
    }
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        // app = docker.build("api")

        //This one works in my docker container jenkins.
        // sh 'docker build -t api .'
        sh "/Applications/Docker.app/Contents/Resources/bin/docker build -t api ."


        //Experiment to see if I can get docker on my personal machine working
        // sh "sh ${DOCKER}/Contents/Resources/bin/docker build -t api . "
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */
         // sh 'docker build -t api .'
         //This should work.
         sh "/Applications/Docker.app/Contents/Resources/bin/docker start laughing_lumiere"
         // sh "/Applications/Docker.app/Contents/Resources/bin/docker container ls -a"
         sh "/Applications/Docker.app/Contents/Resources/bin/docker container logs laughing_lumiere"
         // sh "sleep 3"
         // sh 'curl -f http://127.0.0.1:3000/api || echo "no luck"'
         sh 'curl -f http://0.0.0.0:3000/api || echo "no luck"'
         sh 'curl -f http://0.0.0.0:3000/api || echo "no luck"'

         //
         dir('test'){
           git url: 'https://github.com/benrconway/JenkinsTest2.git'
           nodejs('testJS'){
             sh 'npm install'
             sh 'npm test'
           }
         }
         sh "/Applications/Docker.app/Contents/Resources/bin/docker container logs laughing_lumiere"
         // sh "/Applications/Docker.app/Contents/Resources/bin/docker container logs laughing_lumiere"
         // sh "docker run -p 3000:3000 api"


         //
         // docker.run("api")
         // docker.logs("api")
         //

        // app.run()
        // $echo '' < app.container("logs")
        // trying to see what it written instead of just receiving success  notification
        // app.inside{
        //   sh 'npm test'
        //}
    }
}
