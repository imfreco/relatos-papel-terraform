locals {
  target_groups = {
    frontend = {
      name_suffix = "tg-fe"
      port        = 80
    }
    backend = {
      name_suffix = "tg-be"
      port        = 8080
    }
  }
}
