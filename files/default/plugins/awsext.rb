Ohai.plugin(:AWSExt) do
  provides 'awsext'
  depends 'ec2'
  require 'aws-sdk'

  collect_data do
    aws Mash.new

    # get our region from placement_availability_zone from ohai ec2 hints
    aws[:region] = ec2[:placement_availability_zone].gsub(/[a-z]$/, '')

    # create our connection
    ec2_instance = Aws::EC2::Instance.new(
      region: aws[:region],
      id: ec2[:instance_id]
    )

    # assign an empty hash to the :tags key of aws
    aws[:tags] = {}

    # insert info about our tags into our new hash/key
    ec2_instance.tags.each do |i|
      aws[:tags][i.key.downcase.to_s] = i.value.downcase.to_s
    end
  end
end
