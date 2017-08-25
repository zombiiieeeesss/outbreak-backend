# FriendRequest

### List

`GET /v1/friend-requests`

**Headers:**
`Authorization: your-token`

**Example Response:**
```json
[
  {
    "friend": {
      "email": "email-24@example.com",
      "id": 2556,
      "username": "email-24@example.com"
    },
    "id": 692,
    "requesting_user_id": 2555,
    "status": "pending"
  }
]
```

### Create

`POST /v1/friend-requests/`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |-------- | ---------- | ------------- |
| requested_user_id       | integer  | Yes        | The id of the user being requested for friendship |

**Example Request:**

```json
{
  "requested_user_id": 1
}
```

**Example Response:**

```json
{
  "friend": {
    "email": "email-24@example.com",
    "id": 2556,
    "username": "email-24@example.com"
  },
  "id": 692,
  "requesting_user_id": 2555,
  "status": "pending"
}
```
