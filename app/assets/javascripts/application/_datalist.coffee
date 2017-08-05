(($) ->

  ###
  Application
  ###

  app = undefined
  app = window.Emporium or (window.Emporium = {})
  app._datalist =

    ###
    Datalist
    ###
    
    datalist: (_config) ->
      @datalist_selectElements ||= {}
      @datalist_selectElements[_config.id] = $("##{_config.id}")
      eventSelectize = @datalist_selectElements[_config.id].selectize(
        persist: false
        create: (label, callback) ->
          if !label.length
            return callback()
          _data = {}
          _data[_config.labelKey] = label
          $.ajax
            url: _config.endpoint
            type: 'POST'
            context: @
            data: _data
            error: ->
              callback()
            success: (result) ->
              this.addOption({ value: result[_config.valueKey], text: result[_config.labelKey] })
              ## do not show options
              # this.refreshOptions(true)
              this.setValue(result[_config.valueKey])
              ## does not work as expected
              # callback({ value: result[_config.valueKey], text: result[_config.labelKey] })
              ## remove unused options from previous load()
              _.forEach(this.options, (option) =>
                this.removeOption(option['value']) if result[_config.valueKey] != option['value']
              )
        render:
          option_create: (data, escape) ->
            '<div class="create"><i class="fa fa-plus" aria-hidden="true"></i> <strong>' + escape(data.input) + '</strong>&hellip;</div>'

        load: (label, callback) ->
          $.ajax
            url: _config.endpoint + '?' + _config.labelKey + '=' + encodeURIComponent(label)
            type: 'GET'
            error: ->
              callback()
            success: (res) ->
              callback(_.map(res, (item) ->
                { value: item[_config.valueKey], text: item[_config.labelKey] }
              ))
        createOnBlur: true
        maxItems: 1
        preload: 'focus'
        addPrecedence: true
        onDelete: (values) ->
          this.load((callback) =>
            $.ajax
              url: _config.endpoint
              type: 'GET'
              error: =>
                callback()
              success: (res) =>
                callback(_.map(res, (item) ->
                  { value: item[_config.valueKey], text: item[_config.labelKey] }
                ))
                this.open()
          )
      )


  app._uploader
) jQuery
