class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  connects_to shards: {
    shard_one: { writing: :primary, reading: :primary },
    shard_two: { writing: :primary_shard_two, reading: :primary_shard_two },
    shard_three: { writing: :primary_shard_three, reading: :primary_shard_three },
    shard_four: { writing: :primary_shard_four, reading: :primary_shard_four },
    shard_five: { writing: :primary_shard_five, reading: :primary_shard_five },
    shard_six: { writing: :primary_shard_six, reading: :primary_shard_six },
    shard_seven: { writing: :primary_shard_seven, reading: :primary_shard_seven },
    shard_eight: { writing: :primary_shard_eight, reading: :primary_shard_eight },
  }
end
