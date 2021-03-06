Meteor.methods
	sendMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error 203, t('general.User_logged_out')

		Tracker.nonreactive ->

			message.ts = new Date(Date.now() + TimeSync.serverOffset())
			message.u =
				_id: Meteor.userId()
				username: Meteor.user().username
			message = RocketChat.callbacks.run 'beforeSaveMessage', message

			ChatMessage.upsert
				rid: message.rid
				t: 't'
			,
				$set: message
				$unset:
					t: 1
					expireAt: 1
