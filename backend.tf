terraform {
  backend "gcs" {
    bucket = "itsx25-comerit-team5-tfstate"
    prefix = "terraform/state"
  }
}
