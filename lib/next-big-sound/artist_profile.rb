module NBS

  class ArtistProfile
     METRICS = %w(plays fans views comments downloads likes price)

      attr_accessor :service_type,:url, :artist_id, :options

      def initialize(artist_id,service_type, url="",options={})
        self.service_type = service_type 
        self.artist_id = artist_id 
        self.url = url
      end
      def metrics(sdate,edate)
        @metrics ||= load_metrics(sdate,edate)
      end
      def set_metrics(metrics_array={})
        @metrics = metrics_array
      end
      def load_metrics(sdate,edate)
        metrics ={}
        METRICS.each do |metric_string|
          metrics[metric_string.to_s] = NBS::Metric.new(self.artist_id,self.service_type,metric_string.to_s,sdate,edate)
        end
        return metrics
      end
  end
end