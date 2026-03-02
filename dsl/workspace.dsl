workspace "wattnet" "An open-source service for tracking the environmental footprint of electricity across Europe." {

    !identifiers hierarchical

    # Model

    model {

        properties {
            structurizr.groupSeparator /
        }

        user = person "User" "An individual who accesses and analyzes environmental impact data through wattnet."

        external_consumer = softwareSystem "External Consumer" "A third-party system or service that connects to wattnet to retrieve and use environmental impact data." "External" {
        }

        entsoe_api = softwareSystem "ENTSO-E Public API" "European Network of Transmission System Operators for Electricity RESTful API." "External" {
        }

        elexon_api = softwareSystem "Elexon Insights API" "Elexon Insights RESTful API for operational data about the electricity system in Great Britain." "External" {
        }

        wattnet = softwareSystem "wattnet" "An open-source service for tracking the environmental footprint of electricity across Europe." {

            frontend = group "Frontend" {
                dashboard = container "Dashboard" " The dashboard lets you explore all metrics in a clear, interactive, and visually engaging interface. " "Angular" "Dashboard" {
                    service = component "Service" "Service description."
                }

                grafana = container "Grafana" "Metrics visualization and \n monitoring dashboards. \n Only for monitoring." "Docker: grafana/grafana" "Dashboard/Monitor"{
                }

                tools = container "Data Tools" "Command-line tools for dataset extractor, analyzer, and visualizer." "Python" "Dashboard/Monitor"{
                }
            }

            backend = group  "Backend" {

                api = container "RESTful API" "Provides a stateless standard interface for accessing environmental impact metrics." "FastAPI" {

                    runner = component "API Runner" "Initializes the FastAPI server and manages the API lifecycle." "Python / Uvicorn"

                    v1 = group "v1" {

                        metric_controller = component "Generic Metric Controller" "Handles requests related to system domain metrics, such as generation, import, export, footprint, flow share, mix share, footprint share and factors." "Python / FastAPI"
                        
                    }

                    metrics_service = component "Generic Metric Service" "Contains the business logic for processing and retrieving environmental impact metrics." "Python"

                    geo_service = component "Geo Service" "Provides geographical data and utilities related to latitudes, longitudes, and zone mapping." "Python"

                    operations_service = component "Operations Service" "Provides utilities for performing operations on time-series data, such as aggregation, filtering, and normalization." "Python"

                }

                core_engine = container "Core Engine" "Fetch and processes electricity generation data to compute environmental impact metrics." "Python" {

                    manager = component "Workflow Manager" "Manages the workflow of the metrics engine." "Python"

                    factors_reader = component "Factors Reader" "Reads environmental impact factors from YAML files." "Python"

                    map_builder = component "Map Builder" "Generates the electrical energy map according zones definition and ENTSO-E metrics." "Python"

                    map_printer = component "Map Printer" "Prints the electrical energy map in a visual format for debugging and analysis purposes." "Python"

                    impacts_calculator = component "Impacts Calculator" "Computes electrical energy downstream composition matrix and environmental impact metrics." "Python"

                    flowtracing = component "Flow-Tracing Algorithm" "Computes electrical energy upstream distribution matrix using a flow-tracing approach." "Python"

                    zone_manager = component "Zone Manager" "Handles the zones of the electrical energy map, along with their attributes and status." "Python"

                    providers_manager = component "Providers Manager" "Orchestrates pluggable provider implementations." "Python"

                    provider_interface = component "Provider Interface" "Abstract contract implemented by all providers." "Python"

                    entsoe_client = component "ENTSOE Provider Client" "Retrieves electricity data from ENTSO-E API." "Python"

                    elexon_client = component "Elexon Provider Client" "Retrieves electricity data from Elexon API." "Python"

                    storage_manager = component "Storage Manager" "Handles writing of computed metrics to the metrics storage." "Python"

                    outlier_manager = component "Outlier Manager" "Manages outlier detection and handling in time-series data." "Python"

                    lag_collector = component "Lag Collector" "Collects and manages lag data for outlier detection in time-series data." "Python"

                    outlier_detector = component "Outlier Detector" "Detects outliers in time-series data to ensure data quality." "Python"

                    estimator_manager = component "Estimator Manager" "Manages estimation techniques for handling missing or incomplete data." "Python"

                    estimator_interface = component "Estimator Interface" "Abstract contract implemented by all estimation techniques." "Python"

                    hybrid_energy_estimator = component "Hybrid Energy Estimator" "Combines multiple estimation techniques to infer missing or incomplete data points in time-series data." "Python"

                }

                storage = container "Metrics Storage" "System for storing and retrieving time-series metrics data." "Python + Docker" {

                    metrics_repository = component "Metrics Repository" "Abstraction layer for storing and retrieving metrics. Hides backend details." "Python"
                    
                    time_series_processor = component "Time-Series Processor" "Handles preprocessing of metrics before writing and post-processing after reading (e.g., normalization, filtering)." "Python"

                    storage_manager = component "Storage Backend Manager" "Manages different storage backends and their configurations." "Python"

                    storage_backend_interface = component "Storage Backend Interface" "Abstract contract implemented by all storage backends." "Python"

                    clickhouse_client = component "ClickHouse Client" "Handles connection and queries to the ClickHouse backend." "Python / SQL"

                    clickhouse = component "ClickHouse" "Open-source column-oriented DBMS (columnar database management system) for online analytical processing (OLAP)" "Docker: clickhouse/clickhouse-server"
                }

                forecast_engine = container "Forecast Engine" "Forecasts short-term future environmental impact metrics based on historical data." "Python" {

                    manager = component "Workflow Manager" "Manages the workflow of the forecast engine." "Python"

                    storage_manager = component "Storage Manager" "Reads metrics from storage and writes forecasted values back to the Metrics Repository." "Python"

                    forecast_manager = component "Forecast Manager" "Orchestrates the forecasting process, including data retrieval, and model execution." "Python"

                    lag_collector = component "Lag Collector" "Collects and manages lag data for predictive modeling in time-series data." "Python"

                    predictor_interface = component "Predictor Interface" "Abstract contract implemented by all predictive models." "Python"

                    auto_regressive_predictor = component "Auto-Regressive Predictor" "Predictive model that uses auto-regressive techniques to forecast future metrics based on historical data." "Python"
                }

                impacts_data = container "Impacts Database" "Carbon Neutrality in the UNECE Region: Integrated Life-cycle Assessment of Electricity Sources." "Directory with YAML Files" "Repository" {

                    carbon_intensity_factors = component "Carbon Intensity Factors" "Life-cycle and operational carbon intensity factors for electricity generation technologies."  "YAML File" "Repository-Files"

                    water_footprint_factors = component "Water Footprint Factors" "Life-cycle and operational water footprint factors for electricity generation technologies." "YAML File" "Repository-Files"
                }

                zone_data = container "Zone Database" "Contains metadata about zones, such as their names, EIC codes, and geographical information." "YAML and GEOJSON Files" "Repository" {

                    zones_definition = component "Zones Definition" "Defines zones together with their identifiers, full names, EIC codes, data providers, and cross-border interconnections." "Directory with YAML Files" "Repository-Files"

                    zone_geometries = component "Zone Geometries" "Contains high-resolution geographical boundaries of zones for precise geospatial mapping based on latitude and longitude." "Directory with YAML Files" "Repository-Files"

                    map_geometries = component "Map Geometries" "Contains a single file with low-resolution geographical boundaries of all zones optimized for map visualization." "GEOJSON File" "Repository-Files"

                }   
            }
        }

        # Relationships

        user -> wattnet.dashboard "Uses" "dashboard.wattnet.eu"

        external_consumer -> wattnet.api.runner "Request" "api.wattnet.eu/v1"
        wattnet.dashboard.service -> wattnet.api.runner "Request" "api.wattnet.eu/v1"

        wattnet.api.runner -> wattnet.api.metric_controller "Routes Requests"
        wattnet.api.metric_controller -> wattnet.api.metrics_service "Uses"
        wattnet.api.metrics_service -> wattnet.api.geo_service "Uses"
        wattnet.api.geo_service -> wattnet.zone_data.zone_geometries "Reads" "YAML Files"
        wattnet.api.metrics_service -> wattnet.api.operations_service "Uses"
        wattnet.api.metrics_service -> wattnet.storage.metrics_repository "Reads"

        wattnet.core_engine.manager -> wattnet.core_engine.map_builder "Uses" 
        wattnet.core_engine.manager -> wattnet.core_engine.impacts_calculator "Uses"    
        wattnet.core_engine.manager -> wattnet.core_engine.storage_manager "Uses"
        wattnet.core_engine.storage_manager -> wattnet.storage.metrics_repository "Reads / Writes"

        wattnet.core_engine.map_builder -> wattnet.core_engine.flowtracing "Uses" 
        wattnet.core_engine.map_builder -> wattnet.core_engine.zone_manager "Uses" 
        wattnet.core_engine.map_builder -> wattnet.core_engine.map_printer "Uses"
        wattnet.core_engine.zone_manager -> wattnet.zone_data.zones_definition "Reads" "YAML Files"
        wattnet.core_engine.zone_manager -> wattnet.core_engine.providers_manager "Uses" 
        wattnet.core_engine.providers_manager -> wattnet.core_engine.provider_interface "Uses"
        wattnet.core_engine.entsoe_client -> wattnet.core_engine.provider_interface "Implements"
        wattnet.core_engine.elexon_client -> wattnet.core_engine.provider_interface "Implements"
        wattnet.core_engine.entsoe_client -> entsoe_api "Request Data" "web-api.tp.entsoe.eu/api"
        wattnet.core_engine.elexon_client -> elexon_api "Request Data" "data.elexon.co.uk/bmrs/api/v1"
        wattnet.core_engine.providers_manager -> wattnet.core_engine.outlier_manager "Uses"

        wattnet.core_engine.outlier_manager -> wattnet.core_engine.lag_collector "Uses"
        wattnet.core_engine.outlier_manager -> wattnet.core_engine.outlier_detector "Uses"
        wattnet.core_engine.lag_collector -> wattnet.core_engine.storage_manager "Uses"

        wattnet.core_engine.outlier_manager -> wattnet.core_engine.estimator_manager "Uses"
        wattnet.core_engine.estimator_manager -> wattnet.core_engine.estimator_interface "Uses"
        wattnet.core_engine.hybrid_energy_estimator -> wattnet.core_engine.estimator_interface "Implements"

        wattnet.core_engine.impacts_calculator -> wattnet.core_engine.factors_reader "Fetch"
        wattnet.core_engine.factors_reader -> wattnet.impacts_data "Reads" "YAML Files"
    
        wattnet.storage.metrics_repository -> wattnet.storage.time_series_processor "Uses"
        wattnet.storage.metrics_repository -> wattnet.storage.storage_manager "Uses"
        wattnet.storage.storage_manager -> wattnet.storage.storage_backend_interface "Uses"
        wattnet.storage.clickhouse_client -> wattnet.storage.storage_backend_interface "Implements"
        wattnet.storage.clickhouse_client -> wattnet.storage.clickhouse "Reads / Writes" "SQL"

        wattnet.grafana -> wattnet.storage.clickhouse "Queries" "SQL"
        wattnet.tools -> wattnet.storage.metrics_repository "Reads" 
        wattnet.tools -> wattnet.zone_data.map_geometries "Reads" "GEOJSON Files"

        wattnet.forecast_engine.manager -> wattnet.forecast_engine.forecast_manager "Uses"
        wattnet.forecast_engine.storage_manager -> wattnet.storage.metrics_repository "Reads / Writes"
        wattnet.forecast_engine.forecast_manager -> wattnet.zone_data.zones_definition "Reads" "YAML Files"
        wattnet.forecast_engine.forecast_manager -> wattnet.forecast_engine.storage_manager "Uses"
        wattnet.forecast_engine.forecast_manager -> wattnet.forecast_engine.lag_collector "Uses"
        wattnet.forecast_engine.lag_collector -> wattnet.forecast_engine.storage_manager "Uses"
        wattnet.forecast_engine.forecast_manager -> wattnet.forecast_engine.predictor_interface "Uses"
        wattnet.forecast_engine.auto_regressive_predictor -> wattnet.forecast_engine.predictor_interface "Implements"

        wattnet.dashboard.service -> wattnet.zone_data.map_geometries "Reads" "GEOJSON Files"

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

        component wattnet.core_engine wattnet_core_engine {
            include *
        }

        component wattnet.storage wattnet_storage {
            include *
        }

        component wattnet.forecast_engine wattnet_forecast_engine {
            include *
        }

        component wattnet.zone_data wattnet_zone_data {
            include *
        }
        
        component wattnet.impacts_data wattnet_impacts_data {
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

            element "Dashboard" {
                shape webbrowser
                background #5374A7
                color #ffffff
            }

            element "Dashboard/Monitor" {
                shape webbrowser
                background #5588e6
                color #ffffff
            }

            element "Repository" {
                shape folder
                background #94CE24
                color #143262
            }

            element "Repository-Files" {
                shape folder
                background #c1e859
                color #143262
            }

            element "External" {
                shape roundedbox
                background #0B1C38
                color #e6e6e6
            }

            element "Model" {
                shape folder
                background #2e63c2
                color #ffffff
            }
        }
    }
}
