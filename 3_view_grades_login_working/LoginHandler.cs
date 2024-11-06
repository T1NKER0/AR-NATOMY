using UnityEngine;
using UnityEngine.Networking;
using TMPro;
using System.Collections;

public class LoginHandler : MonoBehaviour
{
    [SerializeField] private GameObject usernameTextGameObject;
    [SerializeField] private GameObject passwordTextGameObject;
    [SerializeField] private CustomSceneManager customSceneManager;

    private TMP_Text usernameTextComponent;
    private TMP_Text passwordTextComponent;
    private string usernameInput = "";
    private string passwordInput = "";
    private string loginUrl = "http://127.0.0.1:8080/sessionServlet";

    public static string UserRole { get; private set; }  // Static field to store the role across scenes

    void Start()
    {
        if (usernameTextGameObject != null)
        {
            usernameTextComponent = usernameTextGameObject.GetComponent<TMP_Text>();
            if (usernameTextComponent == null)
            {
                Debug.LogError("No TextMeshPro component found on the username GameObject!");
            }
        }

        if (passwordTextGameObject != null)
        {
            passwordTextComponent = passwordTextGameObject.GetComponent<TMP_Text>();
            if (passwordTextComponent == null)
            {
                Debug.LogError("No TextMeshPro component found on the password GameObject!");
            }
        }
    }

    public void HandleLogin(string username, string password)
    {
        usernameInput = username;
        passwordInput = password;
        StartCoroutine(LoginCoroutine());
    }

    private IEnumerator LoginCoroutine()
    {
        Debug.Log("Username Input: " + usernameInput);
        Debug.Log("Password Input: " + passwordInput);

        WWWForm form = new WWWForm();
        form.AddField("user", usernameInput);
        form.AddField("pass", passwordInput);

        using (UnityWebRequest request = UnityWebRequest.Post(loginUrl, form))
        {
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.LogError($"Login error: {request.error}");
            }
            else
            {
                string jsonResponse = request.downloadHandler.text;
                Debug.Log($"Login response: {jsonResponse}");

                LoginResponse response = JsonUtility.FromJson<LoginResponse>(jsonResponse);

                if (response.status == "success")
                {
                    Debug.Log("Login successful! User Full Name: " + response.name);
                    Debug.Log("Username: " + response.userName);
                    Debug.Log("Role ID: " + response.roleId);

                    // Store the role in the static variable
                    UserRole = response.roleId;

                    // Switch to the target scene and load the model using CustomSceneManager
                    if (customSceneManager != null)
                    {
                        customSceneManager.SwitchSceneAndLoadModel();
                    }
                    else
                    {
                        Debug.LogError("CustomSceneManager reference is not set!");
                    }
                }
                else
                {
                    Debug.LogWarning("Login failed: " + response.message);
                }
            }
        }
    }

    [System.Serializable]
    private class LoginResponse
    {
        public string status;
        public string message;
        public string name;
        public string userName;
        public string roleId;
    }
}
