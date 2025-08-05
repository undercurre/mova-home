package android.dreame.module.data.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [EventConnectPageEntity::class, EventCommonEntity::class, PluginInfoEntity::class, PluginConfigEntity::class, AppWidgetInfoEntity::class],
    version = 9,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun eventConnectPageDao(): EventConnectPageDao
    abstract fun eventCommonPaeDao(): EventCommonPaeDao
    abstract fun pluginInfoDao(): PluginInfoDao
    abstract fun pluginConfigDao(): PluginConfigDao
    abstract fun appWidgetInfoDao(): AppWidgetInfoDao

    companion object {
        const val EVENT_DATABASE_NAME: String = "dreame-events.db"

        // For Singleton instantiation
        @Volatile
        private var instance: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            return instance ?: synchronized(this) {
                instance ?: buildDatabase(context).also { instance = it }
            }
        }

        // Create and pre-populate the database. See this article for more details:
        // https://medium.com/google-developers/7-pro-tips-for-room-fbadea4bfbd1#4785
        private fun buildDatabase(context: Context): AppDatabase {
            return Room.databaseBuilder(context, AppDatabase::class.java, EVENT_DATABASE_NAME)
                .fallbackToDestructiveMigration()
                .allowMainThreadQueries()
                .build()
        }
    }
}