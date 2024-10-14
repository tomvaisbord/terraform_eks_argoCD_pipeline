# Kubernetes Deployment for weather-app
resource "kubernetes_deployment" "weather_app_deployment" {
  metadata {
    name      = "weather-app-deployment"
    namespace = "default"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        container {
          name  = "weather-app"
          image = "tomvais/weather_app:93"  # Use the correct image tag

          port {
            container_port = 5000
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 10
            period_seconds         = 5
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 15
            period_seconds         = 11
          }
        }
      }
    }
  }
}

# Kubernetes Service for weather-app
resource "kubernetes_service" "weather_app_service" {
  metadata {
    name      = "weather-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "weather-app"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

# Kubernetes Ingress for weather-app service
resource "kubernetes_ingress_v1" "weather_app_ingress" {
  metadata {
    name      = "weather-app-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"            = "alb"
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"  = "ip"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.weather_app_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Kubernetes PodDisruptionBudget for weather-app
resource "kubernetes_pod_disruption_budget_v1" "weather_app_pdb" {
  metadata {
    name      = "weather-app-pdb"
    namespace = "default"
  }

  spec {
    min_available = 1

    selector {
      match_labels = {
        app = "weather-app"
      }
    }
  }
}

# Kubernetes Horizontal Pod Autoscaler for weather-app
resource "kubernetes_horizontal_pod_autoscaler_v2beta2" "weather_app_hpa" {
  metadata {
    name      = "weather-app-hpa"
    namespace = "default"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.weather_app_deployment.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}
