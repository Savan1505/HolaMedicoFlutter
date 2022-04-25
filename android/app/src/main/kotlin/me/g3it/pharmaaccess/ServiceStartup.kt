import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import id.flutter.flutter_background_service.BackgroundService
import me.g3it.pharmaaccess.MainActivity

class ServiceStartup : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        try {
            if (Intent.ACTION_BOOT_COMPLETED == intent!!.action) {
                val i = Intent(context, MainActivity::class.java)
                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context!!.startActivity(i)
            }
        } catch (ex: Exception) {
            Toast.makeText(context, ex.message, Toast.LENGTH_LONG).show()
        }


        try {
            if (Intent.ACTION_BOOT_COMPLETED == intent!!.action) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val i = Intent(context, BackgroundService::class.java)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context!!.startForegroundService(i)
                } else {
                    val i = Intent(context, BackgroundService::class.java)
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context!!.startService(i)
                }
            }

        } catch (ex: Exception) {
            Toast.makeText(context, ex.message, Toast.LENGTH_LONG).show()
        }

    }
}