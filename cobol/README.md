COBOL-Kafka Bank Engine v1.0

OVERVIEW
Distributed systems simulation engine modeling:
- transaction processing
- failure recovery
- observability
- consistency under load

----------------------------

QUICK START

./install.sh
./bank-engine demo

----------------------------

MODES

run      production simulation
demo     full guided execution
stress   load testing
recover  failure recovery
secure   sandbox execution
cap      adaptive consistency mode

----------------------------

ARCHITECTURE

Control Plane -> Execution Plane -> State Layer -> Intelligence Layer -> Control Loop

See docs/ARCHITECTURE.md

----------------------------

TESTING

./tests/system_ci_pipeline.sh
./tests/invariant_validator.sh

----------------------------

PURPOSE

Educational distributed systems model for:
resilience, consistency, observability, recovery design
