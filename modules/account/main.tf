
resource "aws_organizations_organization" "organization" {

}



resource "aws_organizations_organizational_unit" "dev" {
  name      = "dev"
  parent_id = aws_organizations_organization.organization.roots[0].id
}



# define new AWS account
resource "aws_organizations_account" "developer" {
  name  = var.name
  email = var.email
  iam_user_access_to_billing = "ALLOW"
  close_on_deletion = true
  parent_id = aws_organizations_organizational_unit.dev.id

  tags = {
    Name = "engineer-dev"
    Owner = "yousuf"
    Role  = "development"
  }
}

