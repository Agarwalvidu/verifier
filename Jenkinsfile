pipeline{
    agent { label "dev" }
    stages{
        stage("Code Clone"){
            steps{
                git url: "https://github.com/ananyaamishraa/verifier.git", branch: "main"
            }
        }
        stage("Build"){
            steps{
                sh "docker build -t verifier:latest ."
            }
        }
        stage("Push to DockerHub"){
            steps{
                withCredentials([usernamePassword(credentialsId:"DockerHubCreds",
                passwordVariable: "DockerHubPass", usernameVariable: "DockerHubUser")]){
                    sh "docker login -u ${env.DockerHubUser} -p ${env.DockerHubPass}"
                    sh "docker image tag verifier ${env.DockerHubUser}/verifier"
                    sh "docker push ${env.DockerHubUser}/verifier:latest"
                }
            }
        }
        stage("Deploy"){
            steps{
                withCredentials([usernamePassword(credentialsId:"DockerHubCreds",
                passwordVariable: "DockerHubPass", usernameVariable: "DockerHubUser")]) {
                    sh "docker login -u ${env.DockerHubUser} -p ${env.DockerHubPass}"
                    sh "docker rm -f verifier-app || true"
                    sh "docker pull ${env.DockerHubUser}/verifier:latest"
                    sh "docker run -d -p 3000:3000 --name verifier-app ${env.DockerHubUser}/verifier:latest"
                }
            }
        }
    }
    post{
        success{
            emailext (
                to: "ananyamishra6725@gmail.com",
                subject: "Jenkins Build Successful",
                body: "Build Successful",
                from: "ananyamishra6725@gmail.com",
                mimeType: 'text/html'
            )
        }
        failure{
            emailext (
                to: "ananyamishra6725@gmail.com",
                subject: "Jenkins Build Failed", 
                body: "Build Failed",
                from: "ananyamishra6725@gmail.com",
                mimeType: 'text/html'
            )
        }
    }
}
