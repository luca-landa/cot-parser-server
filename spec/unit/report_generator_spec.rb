# frozen_string_literal: true

require_relative '../../src/report_generator'

describe ReportGenerator do
  describe '#latest' do
    it 'does stuff' do
      stub_http_call

      report = described_class.new.latest

      expect(report).to include(
        found_symbols: an_instance_of(Array),
        not_found_symbols: an_instance_of(Array),
        symbols_data: an_instance_of(Hash)
      )
    end
  end

  def stub_http_call
    response = double(Net::HTTPOK)
    allow(response).to receive(:is_a?).with(Net::HTTPOK).and_return true
    allow(response).to receive(:body).and_return report_sample_content

    allow(Net::HTTP).to receive(:get_response).and_return(response)
  end

  def report_sample_content
    path = File.join(File.dirname(__FILE__), '../', 'fixtures/cot_report_sample.html')
    File.read(path)
  end
end
