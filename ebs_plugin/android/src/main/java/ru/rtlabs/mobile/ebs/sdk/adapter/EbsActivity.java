package ru.rtlabs.mobile.ebs.sdk.adapter;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.content.pm.PackageManager;
import java.util.Objects;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import ru.rtlabs.ebs.sdk.adapter.EbsApi;
import ru.rtlabs.ebs.sdk.adapter.VerificationRequest;
import ru.rtlabs.ebs.sdk.adapter.VerificationRequestMode;
import ru.rtlabs.ebs.sdk.adapter.VerificationResult;

public class EbsActivity extends AppCompatActivity {
  // Используется в onRequestPermissionsResult
  int REQUEST_CODE_PERMISSION = 121;
  // Используется в onActivityResult
  int REQUEST_CODE_VERIFICATION = 122;

  // Описание ошибки
  public static final String CAUSE_FIELD = "cause";
  // Секретный токен
  public static final String SECRET_FIELD = "secret";

  // Служебные Extras
  public static final String INPUT_INFO_SYSTEM = "infoSystem";
  public static final String INPUT_ADAPTER_URI = "adapterUri";
  public static final String INPUT_SID = "sid";
  public static final String INPUT_DBO_KO_URI = "dboKoUri";
  public static final String INPUT_DBO_KO_PUBLIC_URI = "dbkKoPublicUri";

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    int hasPerm = this.checkSelfPermission(EbsApi.PERMISSION__VERIFICATION);
    if (hasPerm == PackageManager.PERMISSION_GRANTED) {
      processVerification();
    } else {
      this.requestPermissions(new String[]{EbsApi.PERMISSION__VERIFICATION}, REQUEST_CODE_PERMISSION);
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if(requestCode == REQUEST_CODE_PERMISSION) {
      if(permissions.length != 0 && Objects.equals(permissions[0], EbsApi.PERMISSION__VERIFICATION)) {
        if(grantResults[0] == PackageManager.PERMISSION_GRANTED) {
          processVerification();
        } else {
          processError("Разрешение на верификацию не получено");
        }
      } else {
        processError("Неверное разрешение");
      }
    }
  }

  private void processVerification() {
    Intent intent = getIntent();
    VerificationRequest request = new VerificationRequest.Builder()
        .infoSystem(intent.getStringExtra(INPUT_INFO_SYSTEM))
        .adapterUri(intent.getStringExtra(INPUT_ADAPTER_URI))
        .sid(intent.getStringExtra(INPUT_SID))
        .dboKoUri(intent.getStringExtra(INPUT_DBO_KO_URI))
        .dboKoPublicUri(intent.getStringExtra(INPUT_DBO_KO_PUBLIC_URI))
        .build();
    EbsApi.requestVerification(this, request, REQUEST_CODE_VERIFICATION, VerificationRequestMode.CUSTOM);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if(requestCode == REQUEST_CODE_VERIFICATION) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        VerificationResult result = EbsApi.getVerificationResult(data);
        if (result != null) {
          switch (result.getState()) {
            case SUCCESS:
              processResult(result);
              break;
            case CANCEL:
              processError("Верификация отменена");
              break;
            case FAILURE:
              String error = "Неизвестная ошибка";
              if (result.getErrors() != null && result.getErrors().length > 0) {
                error = String.join(", ", result.getErrors());
              }
              processError("Ошибка верификации: " + error);
              break;
            case REPEAT:
              processError("Ошибка верификации, повторите попытку");
              break;
            default:
              processError("Неизвестный статус верификации");
          }
        } else {
          processError("Результат верификации пуст");
        }
      } else {
        processError("Ошибка возврата из активности");
      }
    }
  }

  private void processResult(@NonNull VerificationResult result) {
    if(result.isValid()) {
      Intent data = new Intent();
      data.putExtra(SECRET_FIELD, result.getSecret());
      setResult(Activity.RESULT_OK, data);
      finish();
    } else {
      processError("Результат верификации не валиден");
    }
  }

  private void processError(@NonNull String cause) {
    Intent data = new Intent();
    data.putExtra(CAUSE_FIELD, cause);
    setResult(Activity.RESULT_CANCELED, data);
    finish();
  }
}