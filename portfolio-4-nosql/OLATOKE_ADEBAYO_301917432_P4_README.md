# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection order_events for order_placed and payment_recorded events. These are fictional event examples based on orders, order_items, customers, products.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original `order_items` record, its key and saved snapshot |
| embedded | Reserved for linked-record details; empty in the current sample documents |
| references | IDs identifying the related orders, customers and products |
| details | Event metadata whose fields vary |

Each event stores a snapshot of its source `order_items` record. Related orders, customers and products are represented by IDs in `references`; their full details are not embedded. The `embedded` object is currently empty in all four sample documents. This is therefore a reference-based model with a source-record snapshot, rather than a model containing full embedded snapshots of every related record. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_items",
        "key": {
            "id": 4
        },
        "snapshot": {
            "id": 4,
            "order_id": 3,
            "product_id": 2,
            "quantity": 2,
            "unit_price": 12.5
        }
    },
    "embedded": {},
    "references": {
        "orders": [
            {
                "key": {
                    "id": 3
                },
                "via": [
                    "order_items.order_id → orders"
                ]
            }
        ],
        "customers": [
            {
                "key": {
                    "id": 1
                },
                "via": [
                    "order_items.order_id → orders.customer_id → customers"
                ]
            }
        ],
        "products": [
            {
                "key": {
                    "id": 2
                },
                "via": [
                    "order_items.product_id → products"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "key": {
        "id": 4
      }
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "key": {
        "id": 8
      }
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("order_events").find({"source.key.id":4}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "id": 4
    }
  },
  {
    "_id": "event_000002",
    "eventType": "payment_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "id": 4
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "id": 4
    }
  },
  {
    "_id": "event_000002",
    "eventType": "payment_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "id": 4
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "id": 8
    }
  },
  {
    "_id": "event_000004",
    "eventType": "payment_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "id": 8
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| order_placed | 2 |
| payment_recorded | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. In these examples, `payment_recorded` contains illustrative metadata only; it does not represent a complete payment record. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run OLATOKE_ADEBAYO_301917432_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/OLATOKE_ADEBAYO_301917432_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

