pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = 'us-east-1'
    }

        stage('Manual Approval') {
            steps {
                input message: "Approve Terraform Destroy?", ok: "Apply"
            }
        }

        stage('Terraform Destroy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat '''
                        setx AWS_ACCESS_KEY_ID %AWS_ACCESS_KEY_ID%
                        setx AWS_SECRET_ACCESS_KEY %AWS_SECRET_ACCESS_KEY%
                        terraform apply -auto-approve -input=false tfplan
                    '''
                }
            }
    post {
        always {
            bat 'terraform workspace show || exit 0'
        }
    }
}



