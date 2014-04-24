class puppet {
  include puppet::install
  include puppet::config
  include puppet::service
}
