using UnityEngine;
using UnityEngine.Networking;
using System.Collections;

public class AssessmentVisibility : MonoBehaviour
{
    public GameObject heartAssessmentButton;
    public GameObject respiratoryAssessmentButton;
    public GameObject gastrointestinalAssessmentButton;

    private string servletUrl = "http://127.0.0.1:8080/arnatomy/AssessmentVisibilityServlet"; // Ensure correct URL

    private void OnEnable()
    {
        Debug.LogWarning("AssessmentVisibility script enabled. Starting visibility update.");
        UpdateVisibility();
    }

    private IEnumerator PostAssessmentVisibility()
    {
        Debug.LogWarning("Starting PostAssessmentVisibility coroutine.");

        // Use POST request to retrieve data
        using (UnityWebRequest request = new UnityWebRequest(servletUrl, "POST"))
        {
            // Add body to the POST request (e.g., sending an empty JSON object or specific data)
            string jsonBody = "{}"; // Can be replaced with actual data if needed
            byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(jsonBody);
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");  // Ensure content type is set to JSON

            // Send the request and wait for the response
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError($"Request failed with error: {request.error}");
            }
            else
            {
                string jsonResponse = request.downloadHandler.text;
                Debug.LogWarning($"Received response: {jsonResponse}");

                // Debugging the response before parsing
                Debug.LogWarning("Debugging JSON response content:");
                Debug.Log($"Raw Response: {jsonResponse}");

                // Parse the JSON response
                try
                {
                    // Deserialize the response
                    AssessmentVisibilityResponse response = JsonUtility.FromJson<AssessmentVisibilityResponse>(jsonResponse);

                    // Check the response status
                    Debug.LogWarning("Response status: " + response.status);

                    // Log each assessment and its visibility status
                    foreach (var assessment in response.assessments)
                    {
                        Debug.LogWarning($"Assessment: {assessment.assessment}, isVisible: {assessment.isVisible}");
                    }

                    if (response.status == "success")
                    {
                        Debug.LogWarning("Response status: success. Processing visibility for each assessment.");

                        // Loop through assessments and update button visibility based on response
                        foreach (var assessment in response.assessments)
                        {
                            switch (assessment.assessment)
                            {
                                case "Heart Assessment":
                                    heartAssessmentButton.SetActive(assessment.isVisible);
                                    Debug.LogWarning($"Heart Assessment visibility set to: {assessment.isVisible}");
                                    break;

                                case "Respiratory System Assessment":
                                    respiratoryAssessmentButton.SetActive(assessment.isVisible);
                                    Debug.LogWarning($"Respiratory System Assessment visibility set to: {assessment.isVisible}");
                                    break;

                                case "Gastrointestinal System Assessment":
                                    gastrointestinalAssessmentButton.SetActive(assessment.isVisible);
                                    Debug.LogWarning($"Gastrointestinal System Assessment visibility set to: {assessment.isVisible}");
                                    break;
                            }
                        }
                    }
                    else
                    {
                        Debug.LogWarning("Failed to retrieve visibility status from server. Response status: " + response.status);
                    }
                }
                catch (System.Exception e)
                {
                    Debug.LogError("Error parsing JSON response: " + e.Message);
                }
            }
        }

        Debug.Log("PostAssessmentVisibility coroutine completed.");
    }

    // Method to trigger visibility update
    public void UpdateVisibility()
    {
        Debug.Log("UpdateVisibility called, starting PostAssessmentVisibility coroutine.");
        StartCoroutine(PostAssessmentVisibility());
    }
}

[System.Serializable]
public class AssessmentVisibilityResponse
{
    public string status;
    public Assessment[] assessments;
}

[System.Serializable]
public class Assessment
{
    public string assessment;
    public bool isVisible;
}
