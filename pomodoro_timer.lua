-- OBS Pomodoro Timer Script
-- A 60-10 Pomodoro timer with visual progress bar, session counter, and sound notifications
-- Compatible with Arch Linux using paplay for sound playback

obs = obslua

-- ============================
-- CONFIGURATION VARIABLES
-- ============================

-- Timer settings
local WORK_DURATION = 60 * 60  -- 60 minutes in seconds
local BREAK_DURATION = 10 * 60 -- 10 minutes in seconds

-- Script state
local timer_running = false
local is_paused = false
local current_time = WORK_DURATION
local is_work_session = true
local completed_sessions = 0
local total_sessions = 8
local timer_callback = nil

-- UI settings (will be set from OBS properties)
local timer_source_name = ""
local label_source_name = ""
local counter_source_name = ""
local progress_source_name = ""
local sound_file_path = ""

-- ============================
-- UTILITY FUNCTIONS
-- ============================

-- Format time as MM:SS
local function format_time(seconds)
local minutes = math.floor(seconds / 60)
local secs = seconds % 60
return string.format("%02d:%02d", minutes, secs)
end

-- Play sound using paplay (Arch Linux)
local function play_sound()
if sound_file_path and sound_file_path ~= "" then
    local command = string.format("paplay '%s' &", sound_file_path)
    os.execute(command)
    end
    end

    -- Update text source with given text
    local function update_text_source(source_name, text)
    if source_name and source_name ~= "" then
        local source = obs.obs_get_source_by_name(source_name)
        if source then
            local settings = obs.obs_data_create()
            obs.obs_data_set_string(settings, "text", text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
            end
            end
            end

            -- Update progress bar (text-based)
            local function update_progress_bar()
            if progress_source_name == "" then return end

                local total_duration = is_work_session and WORK_DURATION or BREAK_DURATION
                local elapsed = total_duration - current_time
                local progress = elapsed / total_duration

                -- Create a 20-character progress bar
                local bar_length = 20
                local filled_chars = math.floor(progress * bar_length)
                local empty_chars = bar_length - filled_chars

                local progress_text = string.rep("▓", filled_chars) .. string.rep("░", empty_chars)
                update_text_source(progress_source_name, progress_text)
                end

                -- Update all display elements
                local function update_display()
                -- Update timer display
                update_text_source(timer_source_name, format_time(current_time))

                -- Update session label
                local label = is_work_session and "Work" or "Break"
                update_text_source(label_source_name, label)

                -- Update session counter
                local counter_text = string.format("%d/%d sessions", completed_sessions, total_sessions)
                update_text_source(counter_source_name, counter_text)

                -- Update progress bar
                update_progress_bar()
                end

                -- ============================
                -- TIMER LOGIC
                -- ============================

                -- Switch between work and break sessions
                local function switch_session()
                if is_work_session then
                    -- Work session ended, start break
                    completed_sessions = completed_sessions + 1
                    is_work_session = false
                    current_time = BREAK_DURATION
                    else
                        -- Break ended, start work
                        is_work_session = true
                        current_time = WORK_DURATION
                        end

                        play_sound()
                        update_display()
                        end

                        -- Timer tick function (called every second)
                        local function timer_tick()
                        if not timer_running or is_paused then
                            return
                            end

                            current_time = current_time - 1

                            if current_time <= 0 then
                                switch_session()
                                    else
                                        update_display()
                                        end
                                        end

                                        -- Start the timer
                                        local function start_timer()
                                        if timer_callback then
                                            obs.timer_remove(timer_callback)
                                            end

                                            timer_running = true
                                            is_paused = false
                                            timer_callback = timer_tick
                                            obs.timer_add(timer_callback, 1000) -- Call every 1000ms (1 second)
                                            update_display()
                                            end

                                            -- Stop the timer
                                            local function stop_timer()
                                            if timer_callback then
                                                obs.timer_remove(timer_callback)
                                                timer_callback = nil
                                                end
                                                timer_running = false
                                                is_paused = false
                                                end

                                                -- Reset the timer
                                                local function reset_timer()
                                                stop_timer()
                                                is_work_session = true
                                                current_time = WORK_DURATION
                                                completed_sessions = 0
                                                update_display()
                                                end

                                                -- Pause/resume the timer
                                                local function toggle_pause()
                                                if timer_running then
                                                    is_paused = not is_paused
                                                    update_display()
                                                    end
                                                    end

                                                    -- ============================
                                                    -- OBS SCRIPT INTERFACE
                                                    -- ============================

                                                    -- Script description
                                                    function script_description()
                                                    return [[
                                                        <h2>Pomodoro Timer for OBS</h2>
                                                        <p>A customizable 60-10 Pomodoro timer with:</p>
                                                        <ul>
                                                        <li>Countdown timer display</li>
                                                        <li>Session counter (completed/total)</li>
                                                        <li>Visual progress bar</li>
                                                        <li>Sound notifications at session end</li>
                                                        <li>Pause/Resume functionality</li>
                                                        </ul>
                                                        <p><strong>Setup Instructions:</strong></p>
                                                        <ol>
                                                        <li>Create text sources in OBS for timer, label, counter, and progress bar</li>
                                                        <li>Configure the source names in the script properties</li>
                                                        <li>Select a sound file (.wav or .mp3)</li>
                                                        <li>Set your desired total sessions count</li>
                                                        <li>Use the Reset and Pause/Resume buttons to control the timer</li>
                                                        </ol>
                                                    ]]
                                                    end

                                                    -- Define script properties
                                                    function script_properties()
                                                    local props = obs.obs_properties_create()

                                                    -- Source selection properties
                                                    obs.obs_properties_add_text(props, "timer_source", "Timer Text Source", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "label_source", "Label Text Source (Work/Break)", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "counter_source", "Session Counter Text Source", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "progress_source", "Progress Bar Text Source", obs.OBS_TEXT_DEFAULT)

                                                    -- Sound file selection
                                                    obs.obs_properties_add_path(props, "sound_file", "Sound File (.wav/.mp3)", obs.OBS_PATH_FILE, "Audio Files (*.wav *.mp3)", nil)

                                                    -- Session configuration
                                                    obs.obs_properties_add_int(props, "total_sessions", "Total Sessions", 1, 50, 1)
                                                    obs.obs_properties_add_int(props, "completed_sessions", "Completed Sessions", 0, 50, 1)

                                                    -- Control buttons
                                                    obs.obs_properties_add_button(props, "reset_timer", "Reset Timer", function()
                                                    reset_timer()
                                                    return true
                                                    end)

                                                    obs.obs_properties_add_button(props, "toggle_pause", "Pause/Resume Timer", function()
                                                    toggle_pause()
                                                    return true
                                                    end)

                                                    obs.obs_properties_add_button(props, "start_timer", "Start Timer", function()
                                                    start_timer()
                                                    return true
                                                    end)

                                                    return props
                                                    end

                                                    -- Load script settings
                                                    function script_update(settings)
                                                    timer_source_name = obs.obs_data_get_string(settings, "timer_source")
                                                    label_source_name = obs.obs_data_get_string(settings, "label_source")
                                                    counter_source_name = obs.obs_data_get_string(settings, "counter_source")
                                                    progress_source_name = obs.obs_data_get_string(settings, "progress_source")
                                                    sound_file_path = obs.obs_data_get_string(settings, "sound_file")
                                                    total_sessions = obs.obs_data_get_int(settings, "total_sessions")
                                                    completed_sessions = obs.obs_data_get_int(settings, "completed_sessions")

                                                    -- Update display when settings change
                                                    update_display()
                                                    end

                                                    -- Set default values
                                                    function script_defaults(settings)
                                                    obs.obs_data_set_string(settings, "timer_source", "Timer")
                                                    obs.obs_data_set_string(settings, "label_source", "Timer Label")
                                                    obs.obs_data_set_string(settings, "counter_source", "Session Counter")
                                                    obs.obs_data_set_string(settings, "progress_source", "Progress Bar")
                                                    obs.obs_data_set_int(settings, "total_sessions", 8)
                                                    obs.obs_data_set_int(settings, "completed_sessions", 0)
                                                    end

                                                    -- Save script settings
                                                    function script_save(settings)
                                                    obs.obs_data_set_int(settings, "completed_sessions", completed_sessions)
                                                    end

                                                    -- Initialize script
                                                    function script_load(settings)
                                                    reset_timer()
                                                    end

                                                    -- Cleanup when script is unloaded
                                                    function script_unload()
                                                    stop_timer()
                                                    end

                                                    -- ============================
                                                    -- HOTKEY SUPPORT (OPTIONAL)
                                                    -- ============================

                                                    -- Register hotkeys for timer control
                                                    function script_properties()
                                                    local props = obs.obs_properties_create()

                                                    -- Source selection properties
                                                    obs.obs_properties_add_text(props, "timer_source", "Timer Text Source", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "label_source", "Label Text Source (Work/Break)", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "counter_source", "Session Counter Text Source", obs.OBS_TEXT_DEFAULT)
                                                    obs.obs_properties_add_text(props, "progress_source", "Progress Bar Text Source", obs.OBS_TEXT_DEFAULT)

                                                    -- Sound file selection
                                                    obs.obs_properties_add_path(props, "sound_file", "Sound File (.wav/.mp3)", obs.OBS_PATH_FILE, "Audio Files (*.wav *.mp3)", nil)

                                                    -- Session configuration
                                                    obs.obs_properties_add_int(props, "total_sessions", "Total Sessions", 1, 50, 1)
                                                    obs.obs_properties_add_int(props, "completed_sessions", "Completed Sessions", 0, 50, 1)

                                                    -- Control buttons
                                                    obs.obs_properties_add_button(props, "reset_timer", "Reset Timer", function()
                                                    reset_timer()
                                                    return true
                                                    end)

                                                    obs.obs_properties_add_button(props, "toggle_pause", "Pause/Resume Timer", function()
                                                    toggle_pause()
                                                    return true
                                                    end)

                                                    obs.obs_properties_add_button(props, "start_timer", "Start Timer", function()
                                                    start_timer()
                                                    return true
                                                    end)

                                                    return props
                                                    end

                                                    -- Register hotkeys
                                                    local hotkey_start_timer = obs.OBS_INVALID_HOTKEY_ID
                                                    local hotkey_pause_timer = obs.OBS_INVALID_HOTKEY_ID
                                                    local hotkey_reset_timer = obs.OBS_INVALID_HOTKEY_ID

                                                    function script_load(settings)
                                                    hotkey_start_timer = obs.obs_hotkey_register_frontend("pomodoro_start", "Start Pomodoro Timer", start_timer)
                                                    hotkey_pause_timer = obs.obs_hotkey_register_frontend("pomodoro_pause", "Pause/Resume Pomodoro Timer", toggle_pause)
                                                    hotkey_reset_timer = obs.obs_hotkey_register_frontend("pomodoro_reset", "Reset Pomodoro Timer", reset_timer)

                                                    reset_timer()
                                                    end

                                                    function script_save(settings)
                                                    obs.obs_data_set_int(settings, "completed_sessions", completed_sessions)

                                                    local hotkey_save_array_start = obs.obs_hotkey_save(hotkey_start_timer)
                                                    local hotkey_save_array_pause = obs.obs_hotkey_save(hotkey_pause_timer)
                                                    local hotkey_save_array_reset = obs.obs_hotkey_save(hotkey_reset_timer)

                                                    obs.obs_data_set_array(settings, "hotkey_start_timer", hotkey_save_array_start)
                                                    obs.obs_data_set_array(settings, "hotkey_pause_timer", hotkey_save_array_pause)
                                                    obs.obs_data_set_array(settings, "hotkey_reset_timer", hotkey_save_array_reset)

                                                    obs.obs_data_array_release(hotkey_save_array_start)
                                                    obs.obs_data_array_release(hotkey_save_array_pause)
                                                    obs.obs_data_array_release(hotkey_save_array_reset)
                                                    end

                                                    function script_update(settings)
                                                    timer_source_name = obs.obs_data_get_string(settings, "timer_source")
                                                    label_source_name = obs.obs_data_get_string(settings, "label_source")
                                                    counter_source_name = obs.obs_data_get_string(settings, "counter_source")
                                                    progress_source_name = obs.obs_data_get_string(settings, "progress_source")
                                                    sound_file_path = obs.obs_data_get_string(settings, "sound_file")
                                                    total_sessions = obs.obs_data_get_int(settings, "total_sessions")
                                                    completed_sessions = obs.obs_data_get_int(settings, "completed_sessions")

                                                    local hotkey_save_array_start = obs.obs_data_get_array(settings, "hotkey_start_timer")
                                                    local hotkey_save_array_pause = obs.obs_data_get_array(settings, "hotkey_pause_timer")
                                                    local hotkey_save_array_reset = obs.obs_data_get_array(settings, "hotkey_reset_timer")

                                                    obs.obs_hotkey_load(hotkey_start_timer, hotkey_save_array_start)
                                                    obs.obs_hotkey_load(hotkey_pause_timer, hotkey_save_array_pause)
                                                    obs.obs_hotkey_load(hotkey_reset_timer, hotkey_save_array_reset)

                                                    obs.obs_data_array_release(hotkey_save_array_start)
                                                    obs.obs_data_array_release(hotkey_save_array_pause)
                                                    obs.obs_data_array_release(hotkey_save_array_reset)

                                                    -- Update display when settings change
                                                    update_display()
                                                    end
