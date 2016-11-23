require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "sheets.googleapis.com-ruby-quickstart.yaml")
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize
ARGV[0] = "-a"
@agent_id = ARGV[1]
ARGV[2] = "-n"
@agent_name = ARGV[3]
ARGV[4] = "-o"
@source_csbm = ARGV[5]
ARGV[6] = "-d"
@dest_csbm = ARGV[7]
ARGV[8] = "-s"
@start_time = ARGV[9]
ARGV[10] = "-e"
@end_time = ARGV[11]
ARGV[12] = "-S"
@size = ARGV[13]
if ARGV.length < 14
	puts "Usage: ./newsheet -a <agent GUID> -n <agent name> -o <old location: CSBM GUID> -d <destination: CSBM ID> -s <start time> -e <end time> -"
	exit
end
spreadsheet_id = '1JSjPUssOkvXaFgWk-UDysEcFInguxP5j4CIdWS0Yo2g'
range = 'Tariq-Use-This!A:G'
value_range_object = {
	major_dimension: "ROWS",
	values: [
          [@agent_id, @agent_name, @source_csbm, @dest_csbm, @size, @start_time, @end_time]
 ]
}
response = service.append_spreadsheet_value(spreadsheet_id, range, valueInputOption=value_range_object, value_input_option: 'USER_ENTERED')
puts ">>>>>>>>> Append response: #{response.inspect}"


