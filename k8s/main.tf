resource "kubernetes_namespace" "sample" {
    metadata {
        name = "sample-namespace"
    }
}

resource "kubernetes_deployment" "sample" {
    metadata {
        name = "nginx-sample"
        namespace = kubernetes_namespace.sample.metadata[0].name
    }
    spec {
        replicas = 2
        selector {
            match_labels = {
                app = "nginx"
            }
        }
        template {
            metadata {
                labels = {
                    app = "nginx"
                }
            }
            spec {
                container {
                    name = "nginx"
                    image = "nginx:1.19"
                    port {
                        container_port = 80
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "sample" {
    metadata {
        name = "nginx-service"
        namespace = kubernetes_namespace.sample.metadata[0].name
    }
    spec {
        selector = {
            app = "nginx"
        }
        port {
            port = 80
            target_port = 80
        }
        type = "NodePort"
    }
}

resource "kubernetes_config_map" "sample" {
    metadata {
        name = "sample-config"
        namespace = kubernetes_namespace.sample.metadata[0].name
    }
    data = {
        ENVIRONMENT = "terraform"
        OWNER = "devops-team"
    }
}

resource "kubernetes_secret" "sample" {
    metadata {
        name = "sample-secret"
        namespace = kubernetes_namespace.sample.metadata[0].name
    }
    data = {
        username = base64encode("admin")
        password = base64encode("password")
    }
}