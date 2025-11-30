package com.example.ebs_plugin;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import ru.example.app.NativeApi;
import ru.example.app.NativeApi.EbsResultData;
import ru.example.app.NativeApi.FlutterError;
import ru.example.app.NativeApi.Result;
import ru.rtlabs.mobile.ebs.sdk.adapter.EbsActivity;
import ru.rtlabs.ebs.sdk.adapter.EbsApi;

/** EbsPlugin */
public class EbsPlugin implements FlutterPlugin, ActivityAware, NativeApi.NativeHostApi, PluginRegistry.ActivityResultListener {
  private Activity activity;
  private MethodChannel channel;
  private ActivityPluginBinding binding;
  private static final String CHANNEL_NAME = "ebs_plugin";
  private NativeApi.Result<NativeApi.EbsResultData> result;
  private static final int REQUEST_CODE = 123; // Любой уникальный код

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
    NativeApi.NativeHostApi.setUp(flutterPluginBinding.getBinaryMessenger(), this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    this.binding = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    this.binding = binding;
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    binding = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void isInstalledApp(@NonNull NativeApi.Result<Boolean> result) {
    try {
      boolean isAppInstalled = ru.rtlabs.ebs.sdk.adapter.EbsApi.isInstalledApp(activity);
      result.success(isAppInstalled);
    } catch (Exception e) {
      result.error(new FlutterError("isInstalledApp", e.getMessage(), e));
    }
  }

  @Override
  public void getAppName(@NonNull NativeApi.Result<String> result) {
    try {
      String appName = ru.rtlabs.ebs.sdk.adapter.EbsApi.getAppName(activity);
      result.success(appName);
    } catch (Exception e) {
      result.error(new FlutterError("getAppName", e.getMessage(), e));
    }
  }

  @Override
  public void getRequestInstallAppText(@NonNull NativeApi.Result<String> result) {
    try {
      String text = ru.rtlabs.ebs.sdk.adapter.EbsApi.getRequestInstallAppText(activity);
      result.success(text);
    } catch (Exception e) {
      result.error(new FlutterError("getRequestInstallAppText", e.getMessage(), e));
    }
  }

  @Override
  public void requestInstallApp(@NonNull NativeApi.Result<Boolean> result) {
    try {
      ru.rtlabs.ebs.sdk.adapter.EbsApi.requestInstallApp(activity);
      result.success(true);
    } catch (Exception e) {
      result.error(new FlutterError("requestInstallApp", e.getMessage(), e));
    }
  }

  @Override
  public void requestVerification(
      @NonNull String infoSystem,
      @NonNull String adapterUri,
      @NonNull String sid,
      @NonNull String dboKoUri,
      @NonNull String dbkKoPublicUri,
      @NonNull NativeApi.Result<NativeApi.EbsResultData> res) {
    if (activity == null) {
      res.error(new FlutterError("requestVerification", "Activity is null", null));
      return;
    }

    Intent intent = new Intent(activity, EbsActivity.class);
    intent.putExtra(EbsActivity.INPUT_INFO_SYSTEM, infoSystem);
    intent.putExtra(EbsActivity.INPUT_ADAPTER_URI, adapterUri);
    intent.putExtra(EbsActivity.INPUT_SID, sid);
    intent.putExtra(EbsActivity.INPUT_DBO_KO_URI, dboKoUri);
    intent.putExtra(EbsActivity.INPUT_DBO_KO_PUBLIC_URI, dbkKoPublicUri);

    binding.getActivity().startActivityForResult(intent, REQUEST_CODE);
    result = res; // Сохраняем результат для последующего использования в onActivityResult
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    if (requestCode == REQUEST_CODE && result != null) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        String secret = data.getStringExtra(EbsActivity.SECRET_FIELD);
        NativeApi.EbsResultData resData = new NativeApi.EbsResultData.Builder()
            .setIsError(false)
            .setSecret(secret)
            .setErrorString(null)
            .build();
        result.success(resData);
      } else if (resultCode == Activity.RESULT_CANCELED && data != null) {
        String errorString = data.getStringExtra(EbsActivity.CAUSE_FIELD);
        NativeApi.EbsResultData resData = new NativeApi.EbsResultData.Builder()
            .setIsError(true)
            .setSecret(null)
            .setErrorString(errorString)
            .build();
        result.success(resData);
      } else {
        // Если resultCode не совпадает с ожидаемыми или data == null
        NativeApi.EbsResultData resData = new NativeApi.EbsResultData.Builder()
            .setIsError(true)
            .setSecret(null)
            .setErrorString("Unexpected result code or null data")
            .build();
        result.success(resData);
      }
      result = null; // Сбрасываем результат
      return true;
    }
    return false;
  }
}
