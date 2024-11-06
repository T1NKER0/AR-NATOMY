using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class TomcatConnector : MonoBehaviour
{
    private string serverUrl = "http://127.0.0.1:8080/getDataBaseJson"; // Update this URL if necessary

    void Start()
    {
        Debug.Log("Starting TomcatConnector to fetch database tables.");
        StartCoroutine(FetchTablesFromServer());
    }

    // Coroutine to fetch the JSON data from the server
    private IEnumerator FetchTablesFromServer()
    {
        using (UnityWebRequest request = UnityWebRequest.Get(serverUrl))
        {
            yield return request.SendWebRequest();

            // Check for network errors
            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError($"Error fetching data from server: {request.error}");
            }
            else
            {
                // Successful response, process JSON
                string jsonResponse = request.downloadHandler.text;
                Debug.Log($"JSON Response from server: {jsonResponse}");

                // Parse JSON response
                TableResponse tables = JsonUtility.FromJson<TableResponse>(jsonResponse);
                
                // Output the table names in Unity's console
                foreach (string tableName in tables.tables)
                {
                    Debug.Log($"Table: {tableName}");
                }
            }
        }
    }

    // JSON response format class for parsing
    [Serializable]
    private class TableResponse
    {
        public string[] tables;
    }
}
