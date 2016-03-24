# "Kafkanetes"

Run [Apache Kafka](https://kafka.apache.org/) and [Apache ZooKeeper](https://zookeeper.apache.org/) on [OpenShift v3](https://www.openshift.com/).

Proof of concept.

Jim Minter, 24/03/2016

## Quick start

Prerequirement: ensure you have persistent storage available in OpenShift.  If not, read [Configuring Persistent Storage](https://docs.openshift.com/enterprise/latest/install_config/persistent_storage/index.html).

1. Clone repository
 ```bash
$ git clone https://github.com/jim-minter/kafkanetes.git
```

1. (Optionally) import templates into OpenShift (requires elevated privileges)

   If you follow this step, as an alternative you can use the UI for all subsequent steps.  If you omit this step, in all subsequent steps substitute `$ oc process -f kafkanetes/foo.yaml | oc create -f -` for `$ oc new-app foo`.

   ```bash
$ for i in kafkanetes/*.yaml; do sudo oc create -f $i -n openshift; done
```

1. Build the Kafkanetes image, containing RHEL, Java, Kafka and its distribution of Zookeeper
   ```bash
$ oc new-app kafkanetes-build
$ oc logs --follow build/kafkanetes-1
```

1. Deploy 3-pod Zookeeper
   ```bash
$ oc new-app kafkanetes-deploy-zk-3
```

1. Deploy 2-pod Kafka
   ```bash
$ oc new-app kafkanetes-deploy-kafka-2
```

## Follow the [Apache Kafka Documentation Quick Start](https://kafka.apache.org/documentation.html#quickstart)

1. Deploy a debugging container and connect to it
   ```bash
$ oc new-app kafkanetes-debug
$ oc rsh $(oc get pods -l deploymentconfig=kafkanetes-debug --template '{{range .items}}{{.metadata.name}}{{end}}')
```

1. Create a topic
   ```bash
bash-4.2$ bin/kafka-topics.sh --create --zookeeper kafkanetes-zk:2181 --replication-factor 1 --partitions 1 --topic test
```

1. List topics
   ```bash
bash-4.2$ bin/kafka-topics.sh --list --zookeeper kafkanetes-zk:2181
```

1. Send some messages
   ```bash
bash-4.2$ bin/kafka-console-producer.sh --broker-list kafkanetes-kafka:9092 --topic test 
foo
bar 
baz
^D
```

1. Receive some messages
   ```bash
bash-4.2$ bin/kafka-console-consumer.sh --zookeeper kafkanetes-zk:2181 --topic test --from-beginning
```

## Notes

* Known issue: with this setup, Kafka advertises itself using a non-qualified domain name, which means that it can only be accessed by clients in the same namespace.

* The forthcoming Kubernetes ["Pet Set"](https://github.com/kubernetes/kubernetes/pull/18016) functionality should help normalise the templates for 3-pod ZooKeeper and 2-pod Kafka.
