using UnityEngine;
using TMPro;

public class UnifiedKeyboardInput : MonoBehaviour
{
    [SerializeField] private GameObject inputKeyboard;
    [SerializeField] private GameObject usernameTextGameObject;
    [SerializeField] private GameObject passwordTextGameObject;
    [SerializeField] private LoginHandler loginHandler;

    private TMP_Text usernameTextComponent;
    private TMP_Text passwordTextComponent;
    private string usernameInput = "";
    private string passwordInput = "";
    private bool isPasswordMode = false;
    private bool isPasswordVisible = false;
    private bool isShiftActive = false;

    private void Start()
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

    public void SwitchToUsernameInput()
    {
        usernameInput = "";
        UpdateUsernameText();
        isPasswordMode = false;
        ShowKeyboard();
    }

    public void SwitchToPasswordInput()
    {
        passwordInput = "";
        UpdatePasswordText();
        isPasswordMode = true;
        ShowKeyboard();
    }

    public void ShowKeyboard()
    {
        if (inputKeyboard != null)
        {
            inputKeyboard.SetActive(true);
        }
    }

    public void CaptureInput(string input)
    {
        if (input == "Backspace")
        {
            if (isPasswordMode && passwordInput.Length > 0)
            {
                passwordInput = passwordInput.Substring(0, passwordInput.Length - 1);
                UpdatePasswordText();
            }
            else if (!isPasswordMode && usernameInput.Length > 0)
            {
                usernameInput = usernameInput.Substring(0, usernameInput.Length - 1);
                UpdateUsernameText();
            }
            return;
        }

        if (input == "\n" || input == "Enter")
        {
            if (isPasswordMode)
            {
                UpdatePasswordText();
            }
            else
            {
                UpdateUsernameText();
            }
            CloseKeyboard();
            return;
        }

        if (isPasswordMode)
        {
            passwordInput += input;
            UpdatePasswordText();
        }
        else
        {
            if (input.Length == 1 && char.IsLetter(input[0]))
            {
                input = isShiftActive ? input.ToUpper() : input.ToLower();
            }

            usernameInput += input;
            UpdateUsernameText();
        }
    }

    private void UpdateUsernameText()
    {
        if (usernameTextComponent != null)
        {
            usernameTextComponent.text = usernameInput;
        }
    }

    private void UpdatePasswordText()
    {
        if (passwordTextComponent != null)
        {
            passwordTextComponent.text = isPasswordVisible ? passwordInput : new string('*', passwordInput.Length);
        }
    }

    private void CloseKeyboard()
    {
        if (inputKeyboard != null)
        {
            inputKeyboard.SetActive(false);
        }
    }

    public void OnLoginButtonClicked()
    {
        // Trigger login only when the login button is clicked
        loginHandler.HandleLogin(usernameInput, passwordInput);
        CloseKeyboard();
    }

    public void TogglePasswordVisibility()
    {
        isPasswordVisible = !isPasswordVisible;
        UpdatePasswordText();
    }

    public void ToggleShift()
    {
        isShiftActive = !isShiftActive;
    }
}
