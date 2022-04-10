"calendly-service": {
    annotations: {}
    attributes: workload: definition: {
        apiVersion: "apps/v1"
        kind:       "Deployment"
    }
    description: "Calendly Component"
    labels: {}
    type: "component"
}

template: {
    output: {
        apiVersion: "apps/v1"
        kind:       "Deployment"
        metadata: name: parameter.name
        spec: {
            selector: matchLabels: app: parameter.name
            replicas:    3
            serviceName: "fuck-\( parameter.name )"
            template: {
                metadata: labels: app: parameter.name
                spec: {
                    containers: [{
                        name: parameter.name
                        ports: [{
                            name: "web"
                            containerPort: 80
                        }]
                        image: "k8s.gcr.io/nginx-slim:0.8"
                    }]
                    terminationGracePeriodSeconds: 10
                }
            }
        }
    }

    outputs: {
		web: {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name: parameter.name
				labels: app: parameter.name
			}
			spec: {
				ports: [{
					name: "web"
					port: 80
				}]
				selector: app: parameter.name
			}
		}
	}

	parameter: {
		image: string
		name: string
		replicas: int
	}
}
