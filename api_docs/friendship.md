# Friendship

### Create

`POST /v1/friendship/`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |-------- | ---------- | ------------- |
| requestee_id       | integer  | Yes        | The id of the user being requested for friendship |

**Example Request:**

```json
{
  "requestee_id": 1
}
```

**Example Response:**

```json
{
  "id": 10
}
```
