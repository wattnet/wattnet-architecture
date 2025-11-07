workspace "wattnet" "An open-source service for tracking the environmental footprint of electricity across Europe." {

    !identifiers hierarchical

    # Model

    model {

        properties {
            structurizr.groupSeparator /
        }

        user = person "User" "An individual who accesses and analyzes environmental impact data through wattnet."

        external_consumer = softwareSystem "External Consumer" "A third-party system or service that connects to wattnet to retrieve and use environmental impact data." "external" {
        }

        entsoe_api = softwareSystem "ENTSO-E Public API" "European Network of Transmission System Operators for Electricity RESTful API." "external" {
        }

        wattnet = softwareSystem "wattnet" "An open-source service for tracking the environmental footprint of electricity across Europe." {

            frontend = group "Frontend" {
                dashboard = container "Dashboard" " The dashboard lets you explore all metrics in a clear, interactive, and visually engaging interface. " "Angular" "dashboard" {
                    service = component "Service" "Service description."
                }

                grafana = container "Grafana" "Metrics visualization and \n monitoring dashboards. \n Only for monitoring." "Docker: grafana/grafana" "dashboard-ops"{
                }
            }

            backend = group  "Backend" {

                api = container "RESTful API" "Provides a stateless standard interface for accessing environmental impact metrics." "FastAPI" {

                    runner = component "API Runner" "Initializes the FastAPI server and manages the API lifecycle." "Python / Uvicorn"

                    v1 = group "v1" {

                        zones_controller = component "Zones Controller" "Handles requests related to zones and cross-border connections." "Python / FastAPI"

                        footprint_controller = component "Footprint Controller" "Handles requests related to environmental impact metrics." "Python / FastAPI"

                        factor_controller = component "Factor Controller" "Handles requests related to environmental impact factors." "Python / FastAPI"

                        status_controller = component "Status Controller" "Handles requests related to the status of the system and subsystems." "Python / FastAPI"
                    }

                    zone_service = component "Zones Service" "Reads zones and cross-border connections from the metrics storage." "Python / PromQL"

                    footprint_service = component "Footprint Service" "Reads environmental impact metrics from the metrics storage." "Python / PromQL"

                    factor_service = component "Factor Service" "Reads environmental impact factors from the metrics storage." "Python / PromQL"

                    storage_api_client = component "Storage API Client" "Handles the connection to the VictoriaMetrics database." "Python / PromQL" 
                }

                core_engine = container "Core Engine" "Fetch and processes electricity generation data to compute environmental impact metrics." "Python" {

                    manager = component "Workflow Manager" "Manages the workflow of the metrics engine." "Python"

                    entsoe_client = component "ENTSO-E Client" "Provides an interface that retrieves and processes electricity market and power grid data from ENTSO-E." "Python"

                    factors_reader = component "Factors Reader" "Reads environmental impact factors from YAML files." "Python"

                    map2metrics = Component "Map2Metrics" "Generates metrics from the map, converting Zone objects into Metrics objects." "Python"

                    factors2metrics = Component "Factors2Metrics" "Generates metrics from the factors, converting Factor objects into Metrics objects." "Python"

                    storage_api_client = component "Storage API Client" "Handles the connection to the VictoriaMetrics database." "Python / PromQL"

                    map_builder = component "Map Builder" "Generates the electrical energy map according zones definition and ENTSO-E metrics." "Python"

                    impacts_calculator = component "Impacts Calculator" "Computes electrical energy downstream composition matrix and environmental impact metrics." "Python"

                    flowtracing = component "Flow-Tracing Algorithm" "Computes electrical energy upstream distribution matrix using a flow-tracing approach." "Python"

                    zone_manager = component "Zone Manager" "Handles the zones of the electrical energy map, along with their attributes and status." "Python"

                    zones_definition = component "Zones Definition" "Specify zones along with their EIC codes, data providers, and cross-border interconnections." "Directory with YAML Files" "repository"

                    provider_connector = component "Provider Connector" "Plug-in system to connect to different electrical energy provider clients." "Python"

                    storage_connector = component "Storage Connector" "Plug-in system to connect to different metrics storage systems." "Python"

                    interpolator = component "Data Interpolator" "Leverages AI-driven self-trained models to intelligently infer missing points on data series." "Python"

                    outlier_detector = component "Outlier Detector" "Detects outliers in time-series data to ensure data quality." "Python"

                }

                storage = container "Metrics Storage" "Metrics storage system for time-series data retention." "Docker: victoriametrics/victoria-metrics" {

                    victoriametrics = component "VictoriaMetrics" "Time-series database for storing and querying metrics." "Docker: victoriametrics/victoria-metrics"

                }

                impacts_db = container "Impacts Database" "Carbon Neutrality in the UNECE Region: Integrated Life-cycle Assessment of Electricity Sources." "Directory with YAML Files" "repository" {
                }

                forecast_engine = container "Forecast Engine" "Forecasts short-term future environmental impact metrics based on historical data." "Python" {

                    manager = component "Workflow Manager" "Manages the workflow of the forecast engine." "Python"

                    storage_connector = component "Storage Connector" "Plug-in system to connect to different metrics storage systems." "Python"

                    storage_api_client = component "Storage API Client" "Handles the connection to the VictoriaMetrics database." "Python / PromQL"

                    lstm = component "LSTM Model" "Long Short-Term Memory model for environmental footprint time-series data forecasting." "Python" "model"

                    drift_detector = component "Drift Detector" "Detects data drift in time-series data to ensure model accuracy." "Python"
                }

                inference_engine = container "Inference Engine" "Trains and applies machine learning models to fill in missing raw data points." "Python" {

                    manager = component "Workflow Manager" "Manages the workflow of the inference engine." "Python"

                    storage_connector = component "Storage Connector" "Plug-in system to connect to different metrics storage systems." "Python"

                    storage_api_client = component "Storage API Client" "Handles the connection to the VictoriaMetrics database." "Python / PromQL"

                    extrapolation_model = component "Extrapolation Model" "Machine learning model for inferring missing data points in time-series data." "Python" "model"

                    drift_detector = component "Drift Detector" "Detects data drift in time-series data to ensure model accuracy." "Python"
                }
            }
        }

        # Relationships

        user -> wattnet.dashboard "Uses" "dashboard.wattnet.eu"

        external_consumer -> wattnet.api.runner "Request" "api.wattnet.eu/v1"
        wattnet.dashboard.service -> wattnet.api.runner "Request" "api.wattnet.eu/v1"

        wattnet.api.runner -> wattnet.api.zones_controller "Uses"
        wattnet.api.runner -> wattnet.api.footprint_controller "Uses"
        wattnet.api.runner -> wattnet.api.factor_controller "Uses"
        wattnet.api.runner -> wattnet.api.status_controller "Uses"

        wattnet.api.zones_controller -> wattnet.api.zone_service "Uses"
        wattnet.api.footprint_controller -> wattnet.api.footprint_service "Uses"
        wattnet.api.factor_controller -> wattnet.api.factor_service "Uses"

        wattnet.api.zone_service -> wattnet.api.storage_api_client "Uses"
        wattnet.api.footprint_service -> wattnet.api.storage_api_client "Uses" 
        wattnet.api.factor_service -> wattnet.api.storage_api_client "Uses"

        wattnet.api.storage_api_client -> wattnet.storage.victoriametrics "Queries" "PromQL"

        wattnet.core_engine.manager -> wattnet.core_engine.map_builder "Uses" 
        wattnet.core_engine.manager -> wattnet.core_engine.impacts_calculator "Uses"    
        wattnet.core_engine.manager -> wattnet.core_engine.map2metrics "Uses" 
        wattnet.core_engine.manager -> wattnet.core_engine.factors2metrics "Uses"
        wattnet.core_engine.manager -> wattnet.core_engine.storage_connector "Uses"
        wattnet.core_engine.storage_connector -> wattnet.core_engine.storage_api_client "Uses"
        wattnet.core_engine.storage_api_client -> wattnet.storage.victoriametrics "Reads / Writes" "PromQL / Remote Write"

        wattnet.core_engine.map_builder -> wattnet.core_engine.flowtracing "Uses" 
        wattnet.core_engine.map_builder -> wattnet.core_engine.zone_manager "Uses" 

        wattnet.core_engine.zone_manager -> wattnet.core_engine.zones_definition "Reads" "YAML Files"
        wattnet.core_engine.zone_manager -> wattnet.core_engine.provider_connector "Uses" 
        wattnet.core_engine.provider_connector -> wattnet.core_engine.entsoe_client "Fetch"
        wattnet.core_engine.provider_connector -> wattnet.core_engine.interpolator "Fetch" "as a fallback"
        wattnet.core_engine.entsoe_client -> entsoe_api "Request" "entsoe.eu/api" 

        wattnet.core_engine.map_builder -> wattnet.core_engine.outlier_detector "Uses"
        wattnet.core_engine.outlier_detector -> wattnet.core_engine.storage_connector "Uses"
        wattnet.core_engine.outlier_detector -> wattnet.core_engine.interpolator "Uses"

        wattnet.core_engine.impacts_calculator -> wattnet.core_engine.factors_reader "Fetch"
        wattnet.core_engine.factors_reader -> wattnet.impacts_db "Reads" "YAML Files"

        wattnet.core_engine.interpolator -> wattnet.inference_engine.extrapolation_model "Uses"
        wattnet.core_engine.interpolator -> wattnet.core_engine.storage_connector "Uses"
    
        wattnet.grafana -> wattnet.storage.victoriametrics "Queries" "PromQL"

        wattnet.inference_engine.manager -> wattnet.inference_engine.storage_connector "Uses"
        wattnet.inference_engine.manager -> wattnet.inference_engine.drift_detector "Uses"
        wattnet.inference_engine.manager -> wattnet.inference_engine.extrapolation_model "Generates"
        wattnet.inference_engine.storage_connector -> wattnet.inference_engine.storage_api_client "Uses"
        wattnet.inference_engine.storage_api_client -> wattnet.storage.victoriametrics "Reads" "PromQL"

        wattnet.forecast_engine.manager -> wattnet.forecast_engine.storage_connector "Uses"
        wattnet.forecast_engine.manager -> wattnet.forecast_engine.drift_detector "Uses"
        wattnet.forecast_engine.manager -> wattnet.forecast_engine.lstm "Generates/Reads"
        wattnet.forecast_engine.storage_connector -> wattnet.forecast_engine.storage_api_client "Uses"
        wattnet.forecast_engine.storage_api_client -> wattnet.storage.victoriametrics "Reads / Writes" "PromQL / Remote Write"

        wattnet.api.status_controller -> wattnet.api.storage_api_client "Health Check" "PromQL"
        wattnet.api.status_controller -> entsoe_api "Health Check" "entsoe.eu/api"
    }

    # Views

    views {

        systemContext wattnet wattnet_context {
            include *
        }

        container wattnet wattnet_container {
            include *
        }

        component wattnet.dashboard wattnet_dashboard {
            include *
        }

        component wattnet.api wattnet_api {
            include *
        }

        component wattnet.core_engine wattnet_engine {
            include *
        }

        component wattnet.storage wattnet_storage {
            include *
        }

        component wattnet.inference_engine wattnet_inference_engine {
            include *
        }

        component wattnet.forecast_engine wattnet_forecast_engine {
            include *
        }

        branding {
            logo "https://raw.githubusercontent.com/jaimeib/hosting/refs/heads/main/wattnet-logo-icon-dark-background-rounded.png"
            font "Red Hat Display" "https://fonts.googleapis.com/css2?family=Red+Hat+Display:wght@500..900"
        }

        styles {

            element "Software System" {
                shape roundedbox
                background #1D488C
                color #ffffff
            }

            element "Person" {
                shape person
                background #143262
                color #ffffff
            }

            element "Container" {
                shape roundedbox
                background #5374A7
                color #ffffff
            }

            element "Component" {
                shape roundedbox
                background #9DB2D0
                color #0B1C38
            }

            element "Group" {
                shape roundedbox
                background #94CE24
                color #94CE24
            }

            element "dashboard" {
                shape webbrowser
                background #5374A7
                color #ffffff
            }

            element "dashboard-ops" {
                shape webbrowser
                background #5588e6
                color #ffffff
            }

            element "repository" {
                shape folder
                background #94CE24
                color #143262
            }

            element "external" {
                shape roundedbox
                background #0B1C38
                color #e6e6e6
            }

            element "model" {
                shape folder
                background #2e63c2
                color #ffffff
            }
        }
    }

}
