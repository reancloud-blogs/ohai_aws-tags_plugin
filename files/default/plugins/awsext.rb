Ohai.plugin(AWSExt)do
  provides 'awsext'
  depends 'ec2'

  aws Mash.new

  aws[:region] = ec2[:placement_availability_zone].gsub(/[a-z]$/, '')

  ec2 = AWS::EC2::Client.new(:region)

  ec2.describe_tags({
    filters: [
      {
        name: "resource-id",
        values: [ ec2[:instance_id] ],
      },
    ],
    max_results: 50,
    })
end
