package expo.modules.errorrecovery

import android.content.Context
import android.content.SharedPreferences

import org.unimodules.core.ExportedModule
import org.unimodules.core.ModuleRegistry
import org.unimodules.core.Promise
import org.unimodules.core.interfaces.ExpoMethod

private const val ERROR_STORE = "expo.modules.errorrecovery.store"

open class ErrorRecoveryModule(context: Context) : ExportedModule(context) {
  protected lateinit var mSharedPreferences: SharedPreferences
  private var propsReadyToSave: String? = null

  override fun getName(): String = "ExpoErrorRecovery"

  override fun onCreate(moduleRegistry: ModuleRegistry) {
    mSharedPreferences = context.applicationContext.getSharedPreferences(ERROR_STORE, Context.MODE_PRIVATE)
  }

  @ExpoMethod
  fun setRecoveryProps(props: String, promise: Promise) {
    propsReadyToSave = props
    promise.resolve(null)
  }

  @ExpoMethod
  fun saveRecoveryProps(promise: Promise) {
    propsReadyToSave?.let {
      pushProps(it)
    }
    promise.resolve(null)
  }

  override fun getConstants(): Map<String, Any?> {
    return mapOf("errors" to popProps())
  }


  protected open fun pushProps(props: String) {
    mSharedPreferences.edit().putString("errorRecovery", props).apply()
  }

  protected open fun popProps(): String? {
    return mSharedPreferences.getString("errorRecovery", null)?.let {
      mSharedPreferences.edit().remove("errorRecovery").apply()
      it
    }
  }
}
