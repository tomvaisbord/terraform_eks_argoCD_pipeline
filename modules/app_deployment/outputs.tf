output "ingress_hostname" {
  value = (
    length(kubernetes_ingress_v1.weather_app_ingress.status[0].load_balancer) > 0 &&
    length(kubernetes_ingress_v1.weather_app_ingress.status[0].load_balancer[0].ingress) > 0
  ) ? kubernetes_ingress_v1.weather_app_ingress.status[0].load_balancer[0].ingress[0].hostname : ""
  description = "The hostname of the ALB created for the Kubernetes ingress"
}
